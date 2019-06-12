package cmd

import (
	"fmt"

	"github.com/spf13/viper"

	"github.com/spf13/cobra"
)

// configCmd represents the config command
var configCmd = &cobra.Command{
	Use:   "config",
	Short: "Edit HomelabOS configuration",
	Long:  `Get and set various HomelabOS configuration values`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Run `config get` or `config set`")
	},
}

var configGetCmd = &cobra.Command{
	Use:   "get",
	Short: "Read a HomelabOS configuration value",
	Long:  `Get a HomelabOS configuration value`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Get!")
	},
}

var configSetCmd = &cobra.Command{
	Use:   "set",
	Short: "Write a HomelabOS configuration value",
	Long:  `Set a HomelabOS configuration value`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(viper.ConfigFileUsed())
		// fmt.Println(viper.Unmarshal())
		viper.WriteConfig()
	},
}

func init() {
	configCmd.AddCommand(configGetCmd)
	configCmd.AddCommand(configSetCmd)
	rootCmd.AddCommand(configCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// configCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	configSetCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
