package cmd

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"sort"
	"text/template"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gitlab.com/nickbusey/homelabos/services"
	"gitlab.com/nickbusey/homelabos/templates"
)

// packageCmd represents the package command
var packageCmd = &cobra.Command{
	Use:   "package",
	Short: "Package HomelabOS.",
	Long:  `This command generates the group_vars/all file, docs/index.md, and config.yml template file.`,
	Run: func(cmd *cobra.Command, args []string) {
		// Generate group_vars/all
		outputFile, err := os.Create("./group_vars/all")
		if err != nil {
			log.Println("create file: ", err)
			return
		}
		servicesList := services.GenerateServicesList("", true)
		template, _ := template.New("group_vars/all").Parse(templates.GroupVarsAll)
		template.Execute(outputFile, servicesList)

		// Generate config.yml.j2
		configFile, err := os.Create("./roles/homelabos_config/templates/config.yml.j2")
		if err != nil {
			log.Println("create file: ", err)
			return
		}
		template, _ = template.New("config").Parse(templates.ConfigTemplate)
		template.Execute(configFile, servicesList)

		// Generate docs/index.md
		docsIndexFile, err := os.Create("./docs/index.md")
		if err != nil {
			log.Println("create file: ", err)
			return
		}

		// Alpha sort services
		var alphaSortedServicesList []services.Service
		keys := make([]string, 0, len(servicesList))
		for k := range servicesList {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, key := range keys {
			alphaSortedServicesList = append(alphaSortedServicesList, servicesList[key])
		}

		// Generate list of services, sorted by category
		categories := services.GetCategories()
		displayCategories := make(map[string]services.Category)
		var displayCategorySlugs []string
		for _, category := range categories {
			var servicesForCategory []services.Service
			for _, service := range alphaSortedServicesList {
				if service.Category.Slug == category.Slug {
					// Category matches, add it to list
					servicesForCategory = append(servicesForCategory, service)
				}
			}
			category.Services = servicesForCategory
			displayCategories[category.Slug] = category
			displayCategorySlugs = append(displayCategorySlugs, category.Slug)
		}

		// Alpha sort categories
		sort.Strings(displayCategorySlugs)
		var alphaSortedCategories []services.Category
		for _, categorySlug := range displayCategorySlugs {
			alphaSortedCategories = append(alphaSortedCategories, displayCategories[categorySlug])
		}

		template, _ = template.New("docs").Parse(templates.DocsIndex)
		template.Execute(docsIndexFile, alphaSortedCategories)

		if viper.GetBool("release") {
			// Marshall doc.md files into the correct place
			if err := os.Mkdir("docs/software", os.ModePerm); err != nil {
			fmt.Println(err)
			}

			for _, service := range servicesList {
				// mv roles/service.name/docs.md docs/software/service.name
				oldLocation := fmt.Sprintf("./roles/%s/docs.md", service.Name)
				newLocation := fmt.Sprintf("./docs/software/%s.md", service.Name)
				// err := os.Rename(oldLocation, newLocation)
				_, err := exec.Command("cp", oldLocation, newLocation).CombinedOutput()
				if err != nil {
					fmt.Println(err)
				}
			}
		}

		fmt.Println("Done")
	},
}

func init() {
	packageCmd.Flags().BoolP("release", "r", false, "Is this for a HomelabOS version release? (If so, include ALL software)")
	viper.BindPFlag("release", packageCmd.Flags().Lookup("release"))
	rootCmd.AddCommand(packageCmd)
}
