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

var servicesList map[string]services.Service

// packageCmd represents the package command
var testCmd = &cobra.Command{
	Use:   "test",
	Short: "Test HomelabOS services",
	Long:  `This command tests every HomelabOS service.`,
	Run: func(cmd *cobra.Command, args []string) {
		servicesList = services.GenerateServicesList(viper.GetString("services"))
		servicesRemaining = len(servicesList)
		serviceCount := servicesRemaining

		watchdog()

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
	},
}

func init() {
	testCmd.Flags().Int("level", 1, "Level of test to run. 1 = Just Sanity. 2 = Full Deploy test.")
	viper.BindPFlag("level", testCmd.Flags().Lookup("level"))
	testCmd.Flags().String("services", "", "Comma delimited list of services to test.")
	viper.BindPFlag("services", testCmd.Flags().Lookup("services"))
	rootCmd.AddCommand(testCmd)
}

func watchdog() {
	// Check if more tests can be started
	for _, service := range servicesList {
		if testsRunning < maxTests {
			status := service.Status
			if status == "_" {
				service.Status = "0"
				servicesList[service.Name] = service
				testsRunning++

				// Start the next test
				go sanityCheck(service)
			}
		}
	}

	if testsRunning > 0 && servicesRemaining > 0 {
		// Restart the watchdog
		watchdog()
	}

}

func sanityCheck(service services.Service) {
	serviceOk := true

	// Detect if the service has a doc file 1
	if _, err := os.Stat("./docs_software/" + service.Name + ".md"); errors.Is(err, os.ErrNotExist) {
		serviceOk = false
	}
	service.Status = "1"

	// Detect if the service is included in docs/index.md 2
	buffer, err := ioutil.ReadFile("docs/index.md")
	if err != nil {
		panic(err)
	}
	fileContents := string(buffer)

	if !strings.Contains(fileContents, service.Name) {
		serviceOk = false
	}
	service.Status = "2"

	// Detect if the service is using the new include style 3
	buffer, err = ioutil.ReadFile("roles/" + service.Name + "/tasks/main.yml")
	if err != nil {
		// File doesn't exist
		serviceOk = false
	}
	fileContents = string(buffer)

	if !strings.Contains(fileContents, "includes/start.yml") {
		serviceOk = false
	}
	service.Status = "3"

	// Output service status
	if serviceOk {
		fmt.Print(string(colorGreen), ".")
		happyServices++
	} else {
		fmt.Print(string(colorRed), "X")
		sadServices++
	}
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
	cmd := exec.Command("./set_setting.sh", service.Name+".enable", "true")
	var out bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		fmt.Println("Failed enabling " + service.Name)
	}
	service.Status = "4"

	// Deploy the service 5
	cmd = exec.Command("make", "update_one", service.Name)

	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		fmt.Println("Failed update_one " + service.Name)
	}
	service.Status = "5"

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
	service.Status = "6"

	// Get screenshot of service (selenium) 7
	cmd = exec.Command("docker", "run", "--rm", "-v", "/Users/nick/Code/HomelabOS:/srv", "lifenz/docker-screenshot", "http://"+service.Name+".164.90.159.227.sslip.io", "roles/"+service.Name+"/files/"+service.Name+".png", "800px", "5000", "1")
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		// fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		fmt.Println("Failed getting screenshot for " + service.Name)
		// return
	}
	service.Status = "7"

	// Disable the service 8
	cmd = exec.Command("./set_setting.sh", service.Name+".enable", "false")
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		return
	}
	service.Status = "8"

	// Put Test Score into service doc

	// Put screenshot into service doc

	// If test is perfect, add to verified service list
	testsRunning--
}
