package cmd

import (
	"bufio"
	"fmt"
	"os/exec"
	"strings"

	"github.com/spf13/cobra"
)

// deployCmd represents the deploy command
var deployCmd = &cobra.Command{
	Use:   "deploy",
	Short: "Deploy HomelabOS",
	Long: `This command will deploy HomelabOS to any servers that are configured,
including cloud bastion hosts.`,
	Run: func(cmd *cobra.Command, args []string) {
		cmdName := "docker"
		cmdArgs := []string{"run", "homelabos", "ansible-playbook", "-i", "inventory", "/HomelabOS/playbook.homelabos.yml"}
		fmt.Println(RunCmd(cmdName, cmdArgs))
	},
}

func init() {
	rootCmd.AddCommand(deployCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// deployCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// deployCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

// RunCmd takes a command and args and runs it, streaming output to stdout
func RunCmd(cmdName string, cmdArgs []string) error {
	fmt.Printf("==> Running: %s %s\n", cmdName, strings.Join(cmdArgs, " "))
	//return fmt.Errorf("bye")
	cmd := exec.Command(cmdName, cmdArgs...)
	cmdReader, err := cmd.StdoutPipe()
	if err != nil {
		return err
	}

	scanner := bufio.NewScanner(cmdReader)
	go func() {
		for scanner.Scan() {
			fmt.Printf("%s\n", scanner.Text())
		}
	}()

	err = cmd.Start()
	if err != nil {
		return err
	}

	err = cmd.Wait()
	if err != nil {
		return err
	}
	return nil
}
