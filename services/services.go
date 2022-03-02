package services

import (
	"fmt"
	"io/ioutil"
	"log"
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
	// Either _ for pending or a number indicating what step it's on
	Status   string
	Category Category
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

		// Pull service settings
		yfile, err := ioutil.ReadFile("./roles/" + serviceName + "/service.yml")

		if err != nil {
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

		category := GetCategory(serviceName)

		version, _ := data["version"]
		if version != nil && len([]rune(version.(string))) > 0 {
			fmt.Println(serviceName)
			services[serviceName] = Service{
				serviceName,
				data["description"].(string), version.(string), additionalConfigsString, "_", category}
		}
	}

	return services
}
