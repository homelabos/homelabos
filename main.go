package main

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

	"github.com/cheggaaa/pb/v3"
)

func main() {
	colorReset := "\033[0m"

	colorRed := "\033[31m"
	colorGreen := "\033[32m"
	colorYellow := "\033[33m"
	colorBlue := "\033[34m"

	files, err := ioutil.ReadDir("./roles")
	if err != nil {
		log.Fatal(err)
	}

	var noDocsServices []string
	var notInIndex []string
	var notUsingIncludes []string

	var serviceCount int
	var happyServices int
	var sadServices int

	fmt.Println("Checking services:")
	fmt.Println()
	for _, file := range files {
		steps := 8
		// create and start new progress bar
		bar := pb.StartNew(steps)

		var serviceName = file.Name()
		fmt.Print(serviceName)
		// Filter out HomelabOS internals
		if !strings.Contains(serviceName, "homelabos") &&
			serviceName != "tor" &&
			serviceName != "docs" {
			serviceOk := true
			serviceCount++
			// Detect if the service has a doc file 1
			if _, err := os.Stat("./docs_software/" + serviceName + ".md"); errors.Is(err, os.ErrNotExist) {
				noDocsServices = append(noDocsServices, serviceName)
				serviceOk = false
			}
			bar.Increment()

			// Detect if the service is included in docs/index.md 2
			buffer, err := ioutil.ReadFile("docs/index.md")
			if err != nil {
				panic(err)
			}
			fileContents := string(buffer)

			if !strings.Contains(fileContents, serviceName) {
				notInIndex = append(notInIndex, serviceName)
				serviceOk = false
			}
			bar.Increment()

			// Detect if the service is using the new include style 3
			buffer, err = ioutil.ReadFile("roles/" + serviceName + "/tasks/main.yml")
			if err != nil {
				// File doesn't exist
				serviceOk = false
			}
			fileContents = string(buffer)

			if !strings.Contains(fileContents, "includes/start.yml") {
				notUsingIncludes = append(notUsingIncludes, serviceName)
				serviceOk = false
			}
			bar.Increment()

			// Test service deploy

			// Enable the service 4
			cmd := exec.Command("./set_setting.sh", serviceName+".enable", "true")
			var out bytes.Buffer
			var stderr bytes.Buffer
			cmd.Stdout = &out
			cmd.Stderr = &stderr
			err = cmd.Run()
			if err != nil {
				// fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
				fmt.Println("Failed enabling " + serviceName)
			}
			bar.Increment()

			// Deploy the service 5
			cmd = exec.Command("make", "update_one", serviceName)

			cmd.Stdout = &out
			cmd.Stderr = &stderr
			err = cmd.Run()
			if err != nil {
				fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
				fmt.Println("Failed update_one " + serviceName)
			}
			bar.Increment()

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
			bar.Increment()

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
			bar.Increment()

			// Disable the service 8
			cmd = exec.Command("./set_setting.sh", serviceName+".enable", "false")
			cmd.Stdout = &out
			cmd.Stderr = &stderr
			err = cmd.Run()
			if err != nil {
				fmt.Println(fmt.Sprint(err) + ": " + stderr.String())
				return
			}
			bar.Increment()
			bar.Finish()

			// Output service status
			if serviceOk {
				fmt.Print(string(colorGreen), ".")
				happyServices++
			} else {
				fmt.Print(string(colorRed), "X")
				sadServices++
			}
		}
	}

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

	fmt.Print("Services without documentation: \n", string(colorYellow))
	for _, serviceName := range noDocsServices {
		fmt.Print(serviceName + "\n")
	}

	fmt.Println(string(colorReset))

	fmt.Print("Services not in documentation index.md: \n", string(colorYellow))
	for _, serviceName := range notInIndex {
		fmt.Print(serviceName + "\n")
	}

	fmt.Println(string(colorReset))

	fmt.Print("Services not using the new includes format: \n", string(colorYellow))
	for _, serviceName := range notUsingIncludes {
		fmt.Print(serviceName + "\n")
	}
}
