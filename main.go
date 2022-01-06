package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
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
	var serviceCount int

	fmt.Println("Checking services:\n")
	for _, file := range files {
		// Filter out HomelabOS internals
		if !strings.Contains(file.Name(), "homelabos") &&
			file.Name() != "tor" &&
			file.Name() != "docs" {
			serviceOk := true
			serviceCount++
			// Detect if the service has a doc file
			if _, err := os.Stat("./docs_software/" + file.Name() + ".md"); errors.Is(err, os.ErrNotExist) {
				noDocsServices = append(noDocsServices, file.Name())
				serviceOk = false
			}

			// Detect if the service is included in docs/index.md
			buffer, err := ioutil.ReadFile("docs/index.md")
			if err != nil {
				panic(err)
			}
			fileContents := string(buffer)

			if !strings.Contains(fileContents, file.Name()) {
				notInIndex = append(notInIndex, file.Name())
				serviceOk = false
			}

			// Output service status
			if serviceOk {
				fmt.Print(string(colorGreen), ".")
			} else {
				fmt.Print(string(colorRed), "X")
			}
		}
	}

	fmt.Println(string(colorReset))
	fmt.Println()
	fmt.Print("Detected services: ", string(colorBlue))
	fmt.Printf("%d\n", serviceCount)
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
}
