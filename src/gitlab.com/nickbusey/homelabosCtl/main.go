package main

import (
	"bufio"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"strings"

	"gitlab.com/nickbusey/homelabosCtl/cmd"
)

func main() {
	// fileURL := "https://gitlab.com/NickBusey/HomelabOS/raw/master/Dockerfile"

	// if err := DownloadFile("/private/tmp/Dockerfile.HomelabOS", fileURL); err != nil {
	// 	panic(err)
	// }

	// fmt.Println("deploy called")

	// fmt.Println(RunCmd("docker", []string{"build", "-f", "/private/tmp/Dockerfile.HomelabOS", ".", "-t", "homelabos"}))

	cmd.Execute()
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

// DownloadFile does just that.
func DownloadFile(filepath string, url string) error {

	// Get the data
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	// Create the file
	out, err := os.Create(filepath)
	if err != nil {
		return err
	}
	defer out.Close()

	// Write the body to file
	_, err = io.Copy(out, resp.Body)
	return err
}
