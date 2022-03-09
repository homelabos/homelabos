package cmd

import (
	"bytes"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gitlab.com/nickbusey/homelabos/services"
)

var happyServices int
var sadServices int

var colorReset string = "\033[0m"
var colorRed string = "\033[31m"
var colorGreen string = "\033[32m"
var colorYellow string = "\033[33m"
var colorBlue string = "\033[34m"

var maxTests = 5
var testsRunning = 0
var servicesRemaining = 0
var maxPoints = 7
var totalPoints = 0

var servicesList map[string]services.Service

// packageCmd represents the package command
var testCmd = &cobra.Command{
	Use:   "test",
	Short: "Test HomelabOS services",
	Long:  `This command tests every HomelabOS service.`,
	Run: func(cmd *cobra.Command, args []string) {
		servicesList = services.GenerateServicesList(viper.GetString("services"), false)
		servicesRemaining = len(servicesList)
		serviceCount := servicesRemaining

		fmt.Println(string(colorReset))
		watchdog(viper.GetInt("verbosity"))

		// Generate group_vars/all based on service list
		fmt.Println(string(colorReset))
		fmt.Println()
		fmt.Print("Detected services: ", string(colorBlue))
		fmt.Printf("%d", serviceCount)
		fmt.Println(string(colorReset))
		fmt.Print("Happy services: ", string(colorGreen))
		fmt.Printf("%d", happyServices)
		fmt.Println(string(colorReset))
		fmt.Print("Sad services: ", string(colorRed))
		fmt.Printf("%d", sadServices)
		fmt.Println(string(colorReset))
		fmt.Printf("Total points: %d\n", totalPoints)
		fmt.Printf("Remaining points to fix: %d\n", serviceCount*maxPoints-totalPoints)
		fmt.Printf("Max possible points: %d\n", serviceCount*maxPoints)
		fmt.Printf("Percent: %.2f\n", float64(totalPoints)/float64(serviceCount*maxPoints)*100)
	},
}

func init() {
	testCmd.Flags().IntP("level", "l", 1, "Level of test to run. 1 = Just Sanity. 2 = Full Deploy test.")
	viper.BindPFlag("level", testCmd.Flags().Lookup("level"))
	testCmd.Flags().IntP("verbosity", "v", 0, "Verbosity level of output. 0 = Minimal. 1 = Debug.")
	viper.BindPFlag("verbosity", testCmd.Flags().Lookup("verbosity"))
	testCmd.Flags().StringP("services", "s", "", "Comma delimited list of services to test.")
	viper.BindPFlag("services", testCmd.Flags().Lookup("services"))
	rootCmd.AddCommand(testCmd)
}

func watchdog(verbosity int) {
	// Check if more tests can be started
	for _, service := range servicesList {
		if testsRunning < maxTests {
			status := service.Status
			if status == -1 {
				service.Status = 0
				servicesList[service.Name] = service
				testsRunning++

				// Start the next test
				go sanityCheck(service, verbosity)
			}
		}
	}

	if testsRunning > 0 || servicesRemaining > 0 {
		// Restart the watchdog
		watchdog(verbosity)
	}

}

func sanityCheck(service services.Service, verbosity int) {
	serviceOk := true

	// Detect if the service has a doc file
	if _, err := os.Stat("./roles/" + service.Name + "/docs.md"); errors.Is(err, os.ErrNotExist) {
		if verbosity > 0 {
			fmt.Println("No doc file found for " + service.Name)
		}
		serviceOk = false
	} else {
		service.Status++
	}

	// Detect if the service has a service.yml file
	buffer, err := ioutil.ReadFile("./roles/" + service.Name + "/service.yml")
	if err != nil {
		if verbosity > 0 {
			fmt.Println("No service file found for " + service.Name)
		}
		serviceOk = false
	} else {
		service.Status++
	}

	// Detect if the service.yml defines a port
	fileContents := string(buffer)
	if !strings.Contains(fileContents, "port:") {
		if verbosity > 0 {
			fmt.Println("Service.yml didn't define a port for " + service.Name)
		}
		serviceOk = false
	} else {
		service.Status++
	}

	// Make sure the service has a task file
	buffer, err = ioutil.ReadFile("roles/" + service.Name + "/tasks/main.yml")
	if err != nil {
		if verbosity > 0 {
			fmt.Println("No task file found for " + service.Name)
		}
		// File doesn't exist
		serviceOk = false
	} else {
		service.Status++
	}

	// Detect if the service is using the new include style
	fileContents = string(buffer)
	if !strings.Contains(fileContents, "includes/start.yml") {
		if verbosity > 0 {
			fmt.Println("Task file not using imports for " + service.Name)
		}
		serviceOk = false
	} else {
		service.Status++
	}

	// Make sure the service has a docker-compose file
	buffer, err = ioutil.ReadFile("roles/" + service.Name + "/templates/docker-compose." + service.Name + ".yml.j2")
	if err != nil {
		if verbosity > 0 {
			fmt.Println("No compose file found for " + service.Name)
		}
		// File doesn't exist
		serviceOk = false
	} else {
		service.Status++
	}

	// Detect if the service is using the new label style
	fileContents = string(buffer)
	if strings.Contains(fileContents, "labels:") {
		if verbosity > 0 {
			fmt.Println("Compose file not using new label format for " + service.Name)
		}
		serviceOk = false
	} else {
		service.Status++
	}

	// Output service status
	if serviceOk {
		if viper.GetInt("verbosity") > 0 {
			fmt.Print(string(colorGreen), "Service OK!: "+service.Name)
		} else {
			fmt.Print(string(colorGreen), ".")
		}
		happyServices++
	} else {
		fmt.Print(string(colorRed), service.Status)
		sadServices++
	}
	totalPoints += service.Status
	if viper.GetInt("level") > 1 {
		deployTest(service)
	} else {
		testsRunning--
		servicesRemaining--
	}
}

func deployTest(service services.Service) {
	// Test service deploy

	// Enable the service 4
	var out bytes.Buffer
	var stderr bytes.Buffer

	// Deploy the service 5
	cmd := exec.Command("make", "update_one", service.Name)

	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		fmt.Println("Failed update_one " + service.Name)
	} else {
		service.Status++
	}

	// Try and hit service, get valid 200, if not wait 10 seconds try again (timeout 5mins) 6
	ii := 0
	success := false
	for ii < 30 && !success {
		resp, err := http.Get("http://" + service.Name + ".164.90.159.227.sslip.io")
		if err != nil {
			log.Fatal(err)
		}

		if resp.StatusCode >= 200 && resp.StatusCode <= 299 {
			success = true
		} else {
			ii++
		}
	}

	// Get screenshot of service (selenium)
	cmd = exec.Command("docker", "run", "--rm", "-v", "/Users/nick/Code/HomelabOS:/srv", "lifenz/docker-screenshot", "http://"+service.Name+".164.90.159.227.sslip.io", "roles/"+service.Name+"/files/"+service.Name+".png", "800px", "5000", "1")
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		// fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		fmt.Println("Failed getting screenshot for " + service.Name)
		// return
	} else {
		service.Status++
	}

	// Disable the service
	cmd = exec.Command("./set_setting.sh", service.Name+".enable", "false")
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		return
	} else {
		service.Status++
	}

	// Put Test Score into service doc

	// Put screenshot into service doc

	// If test is perfect, add to verified service list
	testsRunning--
}
