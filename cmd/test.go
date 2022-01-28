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
	"sort"
	"strings"
	"time"

	"github.com/spf13/cobra"
	"gitlab.com/nickbusey/homelabos/services"
)

var serviceCount int
var happyServices int
var sadServices int

var colorReset string = "\033[0m"
var colorRed string = "\033[31m"
var colorGreen string = "\033[32m"
var colorYellow string = "\033[33m"
var colorBlue string = "\033[34m"

var maxTests = 5
var testsRunning = 0

var servicesStatus = map[string]string{}
var servicesStatusNew = map[string]string{}

// packageCmd represents the package command
var testCmd = &cobra.Command{
	Use:   "test",
	Short: "Test HomelabOS services",
	Long:  `This command tests every HomelabOS service.`,
	Run: func(cmd *cobra.Command, args []string) {
		services.GenerateServicesList()
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
	rootCmd.AddCommand(testCmd)
}

func watchdog() {
	// Check if all services are done
	if true {
		servicesStatus = servicesStatusNew

		keys := make([]string, 0, len(servicesStatusNew))
		for k := range servicesStatusNew {
			keys = append(keys, k)
		}
		sort.Strings(keys)

		// Output test statuses
		for _, serviceName := range keys {
			status := servicesStatus[serviceName]
			fmt.Print(status)

			// Check if more tests can be started
			if testsRunning < maxTests {
				// Start the next test
				go testService(serviceName)
				testsRunning++
			}

		}

		// Sleep and retry
		time.Sleep(time.Second)
		fmt.Println("\033[H\033[2J")
		watchdog()
	}
}

func testService(serviceName string) {
	serviceOk := true

	// Detect if the service has a doc file 1
	if _, err := os.Stat("./docs_software/" + serviceName + ".md"); errors.Is(err, os.ErrNotExist) {
		serviceOk = false
	}
	servicesStatusNew[serviceName] = "1"

	// Detect if the service is included in docs/index.md 2
	buffer, err := ioutil.ReadFile("docs/index.md")
	if err != nil {
		panic(err)
	}
	fileContents := string(buffer)

	if !strings.Contains(fileContents, serviceName) {
		serviceOk = false
	}
	servicesStatusNew[serviceName] = "2"

	// Detect if the service is using the new include style 3
	buffer, err = ioutil.ReadFile("roles/" + serviceName + "/tasks/main.yml")
	if err != nil {
		// File doesn't exist
		serviceOk = false
	}
	fileContents = string(buffer)

	if !strings.Contains(fileContents, "includes/start.yml") {
		serviceOk = false
	}
	servicesStatusNew[serviceName] = "3"

	// Test service deploy

	// Enable the service 4
	cmd := exec.Command("./set_setting.sh", serviceName+".enable", "true")
	var out bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		fmt.Println("Failed enabling " + serviceName)
	}
	servicesStatusNew[serviceName] = "4"

	// Deploy the service 5
	cmd = exec.Command("make", "update_one", serviceName)

	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		fmt.Println("Failed update_one " + serviceName)
	}
	servicesStatusNew[serviceName] = "5"

	// Try and hit service, get valid 200, if not wait 10 seconds try again (timeout 5mins) 6
	ii := 0
	success := false
	for ii < 30 && !success {
		resp, err := http.Get("http://" + serviceName + ".164.90.159.227.sslip.io")
		if err != nil {
			log.Fatal(err)
		}

		if resp.StatusCode >= 200 && resp.StatusCode <= 299 {
			success = true
		} else {
			ii++
		}
	}
	servicesStatusNew[serviceName] = "6"

	// Get screenshot of service (selenium) 7
	cmd = exec.Command("docker", "run", "--rm", "-v", "/Users/nick/Code/HomelabOS:/srv", "lifenz/docker-screenshot", "http://"+serviceName+".164.90.159.227.sslip.io", "roles/"+serviceName+"/files/"+serviceName+".png", "800px", "5000", "1")
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		// fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		fmt.Println("Failed getting screenshot for " + serviceName)
		// return
	}
	servicesStatusNew[serviceName] = "7"

	// Disable the service 8
	cmd = exec.Command("./set_setting.sh", serviceName+".enable", "false")
	cmd.Stdout = &out
	cmd.Stderr = &stderr
	err = cmd.Run()
	if err != nil {
		fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
		return
	}
	servicesStatusNew[serviceName] = "8"

	// Put Test Score into service doc

	// Put screenshot into service doc

	// If test is perfect, add to verified service list

	// Output service status
	if serviceOk {
		fmt.Print(string(colorGreen), ".")
		happyServices++
	} else {
		fmt.Print(string(colorRed), "X")
		sadServices++
	}
}
