package cmd

import (
	"fmt"
	"os"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var debug bool

var rootCmd = &cobra.Command{
	Use:   "hlos-dash-server",
	Short: "HomelabOS dashboard server",
	Long:  "Expose a local HTTP API for reading and managing a HomelabOS installation.",
	RunE:  runServe,
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})
		if debug {
			zerolog.SetGlobalLevel(zerolog.TraceLevel)
			log.Info().Msg("Debug mode enabled")
		} else {
			zerolog.SetGlobalLevel(zerolog.InfoLevel)
		}
	},
}

func init() {
	rootCmd.PersistentFlags().BoolVarP(&debug, "debug", "d", false, "Display debugging output in the console.")
	_ = viper.BindPFlag("debug", rootCmd.PersistentFlags().Lookup("debug"))
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
