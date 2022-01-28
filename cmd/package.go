package cmd

import (
	"fmt"
	"log"
	"os"
	"text/template"

	"github.com/spf13/cobra"
	"gitlab.com/nickbusey/homelabos/services"
	"gitlab.com/nickbusey/homelabos/templates"
)

// packageCmd represents the package command
var packageCmd = &cobra.Command{
	Use:   "package",
	Short: "Package HomelabOS.",
	Long: `This command generates the group_vars/all file with the list of services.
It also generates the config.yml template file.`,
	//It also generates the docs/index.md 'Included Software' section.`,
	Run: func(cmd *cobra.Command, args []string) {
		// Generate group_vars/all
		outputFile, err := os.Create("./group_vars/all")
		if err != nil {
			log.Println("create file: ", err)
			return
		}
		services := services.GenerateServicesList("")
		template, _ := template.New("group_vars/all").Parse(templates.GroupVarsAll)
		template.Execute(outputFile, services)

		// Generate config.yml.j2
		configFile, err := os.Create("./roles/homelabos_config/templates/config.yml.j2")
		if err != nil {
			log.Println("create file: ", err)
			return
		}
		template, _ = template.New("config").Parse(templates.ConfigTemplate)
		template.Execute(configFile, services)

		fmt.Println("Done")
	},
}

func init() {
	rootCmd.AddCommand(packageCmd)
}
