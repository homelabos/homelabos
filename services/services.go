package services

import (
	"io/ioutil"
	"log"
	"strings"

	"gopkg.in/yaml.v3"
)

var services []Service
var servicesStatus = map[string]string{}
var servicesStatusNew = map[string]string{}

type Service struct {
	Name              string
	Version           string
	AdditionalConfigs string
}

func GenerateServicesList() []Service {
	files, err := ioutil.ReadDir("./roles")
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		// steps := 8
		// create and start new progress bar

		var serviceName = file.Name()
		servicesStatusNew[serviceName] = "_"
		// Filter out HomelabOS internals
		if !strings.Contains(serviceName, "homelabos") &&
			serviceName != "tor" {
			// Generate list of services

			// Pull version number
			yfile, err := ioutil.ReadFile("./roles/" + serviceName + "/service.yml")

			if err != nil {
				services = append(services, Service{serviceName, "latest", ""})
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
					services = append(services, Service{serviceName, value.(string), additionalConfigsString})
				}
			}
		}
	}
	return services
}
