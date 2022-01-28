package services

import (
	"io/ioutil"
	"log"
	"strings"

	"gopkg.in/yaml.v3"
)

var services map[string]Service
var serviceNames []string

type Service struct {
	Name              string
	Version           string
	AdditionalConfigs string
	// Either _ for pending or a number indicating what step it's on
	Status string
}

func GenerateServicesList(servicesFilter string) map[string]Service {
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

			// Filter out HomelabOS internals
			if !strings.Contains(serviceName, "homelabos") &&
				serviceName != "tor" {
				serviceNames = append(serviceNames, serviceName)
			}
		}
	}

	for _, serviceName := range serviceNames {
		// Generate list of services
		// Pull version number
		yfile, err := ioutil.ReadFile("./roles/" + serviceName + "/service.yml")

		if err != nil {
			services[serviceName] = Service{serviceName, "latest", "", "_"}
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
		for key, value := range data {
			if key == "version" {
				services[serviceName] = Service{serviceName, value.(string), additionalConfigsString, "_"}
			}
		}
	}

	return services
}
