package cmd

import (
	"context"
	"errors"
	"fmt"
	"net"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gitlab.com/nickbusey/homelabos/hlos_dash/server/pkg/homelabos"
	"gitlab.com/nickbusey/homelabos/hlos_dash/server/pkg/interfaces/httpapi"
)

var (
	serveHost                string
	servePort                int
	serveHomelabOSInstallDir string
	serveSourceDir           string
	serveAPIToken            string
	serveDBPath              string
)

var serveCmd = &cobra.Command{
	Use:   "serve",
	Short: "Run the HTTP API server",
	RunE:  runServe,
}

func runServe(cmd *cobra.Command, args []string) error {
	apiToken := resolveAPIToken()
	if strings.TrimSpace(apiToken) == "" {
		return errors.New("api token is required; set --api-token or HLOS_DASH_API_TOKEN")
	}

	ctx, stop := signal.NotifyContext(cmd.Context(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	host := resolveHost()
	port := resolvePort()
	installDir := resolveHomelabOSInstallDir()
	repoDir := resolveSourceDir()
	handler := httpapi.NewHandler(httpapi.Config{
		APIToken:            apiToken,
		HomelabOSInstallDir: installDir,
		SourceDir:           repoDir,
		DBPath:              resolveDBPath(),
	})
	apiServer := &http.Server{
		Addr:              net.JoinHostPort(host, fmt.Sprintf("%d", port)),
		Handler:           handler,
		ReadHeaderTimeout: 5 * time.Second,
	}

	errCh := make(chan error, 1)
	go func() {
		log.Info().Str("addr", apiServer.Addr).Str("homelabos_install_dir", installDir).Str("hlos_dash_source_dir", repoDir).Msg("Starting HTTP API server")
		if err := apiServer.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			errCh <- fmt.Errorf("http api server error: %w", err)
		}
	}()

	var runErr error
	select {
	case runErr = <-errCh:
		log.Error().Err(runErr).Msg("Serve command exiting due to error")
	case <-ctx.Done():
	}

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	_ = apiServer.Shutdown(shutdownCtx)

	return runErr
}

func init() {
	serveCmd.Flags().StringVar(&serveHost, "host", "127.0.0.1", "HTTP API bind host")
	serveCmd.Flags().IntVar(&servePort, "port", 8081, "HTTP API bind port")
	serveCmd.Flags().StringVar(&serveHomelabOSInstallDir, "homelabos-install-dir", homelabos.DefaultInstallDir, "HomelabOS install directory")
	serveCmd.Flags().StringVar(&serveSourceDir, "source-dir", "..", "Source repository directory")
	serveCmd.Flags().StringVar(&serveAPIToken, "api-token", "", "Bearer token required for protected API endpoints")
	serveCmd.Flags().StringVar(&serveDBPath, "db-path", "", "SQLite database path for dashboard user settings")

	_ = viper.BindPFlag("hlos_dash_host", serveCmd.Flags().Lookup("host"))
	_ = viper.BindPFlag("hlos_dash_port", serveCmd.Flags().Lookup("port"))
	_ = viper.BindPFlag("homelabos_install_dir", serveCmd.Flags().Lookup("homelabos-install-dir"))
	_ = viper.BindPFlag("hlos_dash_source_dir", serveCmd.Flags().Lookup("source-dir"))
	_ = viper.BindPFlag("hlos_dash_api_token", serveCmd.Flags().Lookup("api-token"))
	_ = viper.BindPFlag("hlos_dash_db_path", serveCmd.Flags().Lookup("db-path"))
	_ = viper.BindEnv("hlos_dash_host", "HLOS_DASH_HOST")
	_ = viper.BindEnv("hlos_dash_port", "HLOS_DASH_PORT")
	_ = viper.BindEnv("homelabos_install_dir", "HOMELABOS_INSTALL_DIR")
	_ = viper.BindEnv("hlos_dash_source_dir", "HLOS_DASH_SOURCE_DIR")
	_ = viper.BindEnv("hlos_dash_api_token", "HLOS_DASH_API_TOKEN")
	_ = viper.BindEnv("hlos_dash_db_path", "HLOS_DASH_DB_PATH")

	rootCmd.AddCommand(serveCmd)
}

func resolveHost() string {
	if host := strings.TrimSpace(viper.GetString("hlos_dash_host")); host != "" {
		return host
	}
	return serveHost
}

func resolvePort() int {
	if viper.IsSet("hlos_dash_port") {
		return viper.GetInt("hlos_dash_port")
	}
	return servePort
}

func resolveHomelabOSInstallDir() string {
	if installDir := strings.TrimSpace(viper.GetString("homelabos_install_dir")); installDir != "" {
		return installDir
	}
	return serveHomelabOSInstallDir
}

func resolveSourceDir() string {
	if repoDir := strings.TrimSpace(viper.GetString("hlos_dash_source_dir")); repoDir != "" {
		return repoDir
	}
	return serveSourceDir
}

func resolveAPIToken() string {
	if apiToken := strings.TrimSpace(viper.GetString("hlos_dash_api_token")); apiToken != "" {
		return apiToken
	}
	return serveAPIToken
}

func resolveDBPath() string {
	if dbPath := strings.TrimSpace(viper.GetString("hlos_dash_db_path")); dbPath != "" {
		return dbPath
	}
	return serveDBPath
}
