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
	Status         int
	Category       Category
	Port           int
	DefaultEnabled bool
	SanityIgnore   bool
}

func loadAdditionalServicesSourceMap() map[string]string {
	sourceServices := make(map[string]string)

	yfile, err := ioutil.ReadFile("./settings/additional_services_config.yml")
	if err != nil {
		return sourceServices
	}

	data := make(map[interface{}]interface{})
	if err := yaml.Unmarshal(yfile, &data); err != nil {
		return sourceServices
	}

	for serviceName, config := range data {
		name, ok := serviceName.(string)
		if !ok || name == "blank_on_purpose" {
			continue
		}

		configMap, ok := config.(map[interface{}]interface{})
		if !ok {
			continue
		}

		sourceService, ok := configMap["source_service"].(string)
		if ok && sourceService != "" {
			sourceServices[name] = sourceService
		}
	}

	return sourceServices
}

func loadServiceFromRole(roleName string) (Service, error) {
	yfile, err := ioutil.ReadFile("./roles/" + roleName + "/service.yml")
	if err != nil {
		return Service{}, err
	}

	data := make(map[interface{}]interface{})
	if err := yaml.Unmarshal(yfile, &data); err != nil {
		return Service{}, err
	}

	additionalConfigsFile, err := ioutil.ReadFile("./roles/" + roleName + "/additional_configs.yml")
	additionalConfigsString := ""
	if err == nil {
		additionalConfigsString = string(additionalConfigsFile)
	}

	version := fmt.Sprintf("%v", data["version"])
	port := data["port"]
	if version == "" {
		version = "latest"
	}
	if port == nil || port == false {
		port = 0
	}

	category := GetCategory(data["category"].(string))

	defaultEnabled := false
	if value, ok := data["default_enabled"]; ok {
		if b, ok := value.(bool); ok {
			defaultEnabled = b
		}
	}

	return Service{
		roleName,
		data["description"].(string),
		version,
		additionalConfigsString,
		-1,
		category,
		port.(int),
		defaultEnabled,
		false,
	}, nil
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

	additionalServiceSources := loadAdditionalServicesSourceMap()

	// Load additional services
	if includeAdditionalServices {
		for serviceName := range additionalServiceSources {
			serviceNames = append(serviceNames, serviceName)
		}
	}

	for _, serviceName := range serviceNames {
		// Generate list of services
		// Pull service settings
		service, err := loadServiceFromRole(serviceName)

		if err != nil {
			if sourceService, ok := additionalServiceSources[serviceName]; ok {
				sourceServiceData, sourceErr := loadServiceFromRole(sourceService)
				if sourceErr == nil {
					sourceServiceData.Name = serviceName
					services[serviceName] = sourceServiceData
					continue
				}
			}

			// If we don't have a service file, add the service anyway, so it shows up as failing.
			services[serviceName] = Service{serviceName, "", "latest", "", -1, GetCategory("misc-other"), 0, false, false}
			continue
		}

		services[serviceName] = service
	}

	return services
}
