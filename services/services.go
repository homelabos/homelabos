package services

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"

	"gopkg.in/yaml.v3"
)

var services map[string]Service
var serviceNames []string

type Service struct {
	Name              string
	Description       string
	Version           string
	AdditionalConfigs string
	// Either -1 for pending or a number indicating what step it last succeeded
	Status   int
	Category Category
	Port     int
}

func GenerateServicesList(servicesFilter string, includeAdditionalServices bool) map[string]Service {
	services = make(map[string]Service)

	if len(servicesFilter) > 0 {
		serviceNames = strings.Split(servicesFilter, ",")
	} else {
		files, err := ioutil.ReadDir("./roles")
		if err != nil {
			log.Fatal(err)
		}

		for _, file := range files {
			var serviceName = file.Name()
			info, _ := os.Stat("./roles/" + file.Name())
			if info.IsDir() &&
				!strings.Contains(serviceName, "homelabos") &&
				serviceName != "tor" {
				serviceNames = append(serviceNames, serviceName)
			}
		}
	}

	// Load additional services
	if includeAdditionalServices {
		yfile, err := ioutil.ReadFile("./settings/additional_services_config.yml")

		if err == nil {
			data := make(map[interface{}]interface{})
			err2 := yaml.Unmarshal(yfile, &data)
			if err2 != nil {
				log.Fatal(err2)
			}
			for serviceName, _ := range data {
				if serviceName != "blank_on_purpose" {
					serviceNames = append(serviceNames, serviceName.(string))
				}
			}
		}
	}

	for _, serviceName := range serviceNames {
		// Generate list of services
		// Pull service settings
		yfile, err := ioutil.ReadFile("./roles/" + serviceName + "/service.yml")

		if err != nil {
			// If we don't have a service file, add the service anyway, so it shows up as failing.
			services[serviceName] = Service{serviceName, "", "latest", "", -1, GetCategory("misc-other"), 0}
			continue
		}
		data := make(map[interface{}]interface{})
		err2 := yaml.Unmarshal(yfile, &data)
		if err2 != nil {
			log.Fatal(err2)
		}

		additionalConfigsFile, err := ioutil.ReadFile("./roles/" + serviceName + "/additional_configs.yml")
		additionalConfigsString := ""
		if err == nil {
			additionalConfigsString = string(additionalConfigsFile)
		}

		fmt.Println(serviceName)
		version := fmt.Sprintf("%f", data["version"])
		port := data["port"]
		if version != "" && port != nil && port != false && len([]rune(version)) > 0 {
			category := GetCategory(data["category"].(string))
			services[serviceName] = Service{
				serviceName,
				data["description"].(string), version, additionalConfigsString, -1, category, port.(int)}
		} else {
			services[serviceName] = Service{serviceName, "", "latest", "", -1, GetCategory("misc-other"), 0}
		}
	}

	return services
}
