package main

import (
	"github.com/spf13/viper"
	"gitlab.com/nickbusey/homelabos/hlos_dash/server/cmd"
)

func main() {
	viper.SetConfigType("env")
	viper.SetConfigFile(".env")
	_ = viper.ReadInConfig()
	viper.SetConfigType("env")
	viper.SetConfigFile(".env.local")
	_ = viper.MergeInConfig()
	viper.AutomaticEnv()
	cmd.Execute()
}
