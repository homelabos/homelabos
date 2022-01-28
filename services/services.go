package services

import (
	"io/ioutil"
	"log"
	"strings"

	"gopkg.in/yaml.v3"
)

var services map[string]Service

type Service struct {
	Name              string
	Version           string
	AdditionalConfigs string
	// Either _ for pending or a number indicating what step it's on
	Status string
}

func GenerateServicesList() map[string]Service {
	services = make(map[string]Service)
	files, err := ioutil.ReadDir("./roles")
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		// steps := 8
		// create and start new progress bar

		var serviceName = file.Name()

		// Filter out HomelabOS internals
		if !strings.Contains(serviceName, "homelabos") &&
			serviceName != "tor" {
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
	}
	return services
}
