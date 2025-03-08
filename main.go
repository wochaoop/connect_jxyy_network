package main

import (
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"

	"gopkg.in/yaml.v2"
)

type Config struct {
	Callback     string `yaml:"callback"`
	LoginMethod  string `yaml:"login_method"`
	IPv4         string `yaml:"ipv4"`
	IPv6         string `yaml:"ipv6"`
	MAC          string `yaml:"mac"`
	InletIP      string `yaml:"inlet_ip"`
	UserAgent    string `yaml:"ua"`
	Account      string `yaml:"account"`
	Password     string `yaml:"password"`
	Operator     string `yaml:"operator"`
	MaxAttempts  int    `yaml:"max_attempts"`
	AttemptDelay int    `yaml:"attempt_delay"`
	OnlyOnce     bool   `yaml:"only_once"`
}

func main() {
	configFile := flag.String("config", "./config.yaml", "配置文件的路径")
	flag.Parse()

	config, err := loadConfig(*configFile)
	if err != nil {
		fmt.Printf("[%s] 读取配置文件失败: %v\n", currentTime(), err)
		return
	}

	client := &http.Client{Timeout: 5 * time.Second} // Reuse HTTP client

	loginDone := make(chan struct{}) // Channel to signal login completion
	defer close(loginDone)

	go func() {
		defer func() { loginDone <- struct{}{} }()

		loginIfNeeded(config, client)
		if config.OnlyOnce {
			return
		}
	}()

	for range loginDone {
		// Handle login completion
		sleep(config.AttemptDelay)
	}
}

func loginIfNeeded(config *Config, client *http.Client) {
	for {
		resp, err := client.Get(fmt.Sprintf("http://%s/", config.InletIP))
		if err == nil && resp.StatusCode >= 200 && resp.StatusCode < 300 {
			body, err := io.ReadAll(resp.Body)
			_ = resp.Body.Close()

			if err == nil {
				responseBody := string(body)

				if strings.Contains(responseBody, "Dr.COMWebLoginID_0.htm") {
					loginURL := fmt.Sprintf("http://%s:801/eportal/portal/login", config.InletIP)
					loginParams := []string{
						fmt.Sprintf("callback=%s", config.Callback),
						fmt.Sprintf("login_method=%s", config.LoginMethod),
						fmt.Sprintf("user_account=,0,%s@%s", config.Account, config.Operator),
						fmt.Sprintf("user_password=%s", config.Password),
						fmt.Sprintf("wlan_user_ip=%s", config.IPv4),
						fmt.Sprintf("wlan_user_ipv6=%s", config.IPv6),
						fmt.Sprintf("wlan_user_mac=%s", config.MAC),
					}
					loginURLWithParams := fmt.Sprintf("%s?%s", loginURL, strings.Join(loginParams, "&"))

					_, err := client.Get(loginURLWithParams)
					if err != nil {
						logMessage(fmt.Sprintf("登录时出现错误: %v", err))
					} else {
						logMessage("登录成功")
					}
				}
			}
		}

		time.Sleep(time.Duration(config.AttemptDelay) * time.Second)
	}
}

func currentTime() string {
	return time.Now().Format("2006-01-02 15:04:05")
}

func logMessage(msg string) {
	fmt.Printf("[%s] %s\n", currentTime(), msg)
}

func sleep(seconds int) {
	time.Sleep(time.Duration(seconds) * time.Second)
}

func loadConfig(filename string) (*Config, error) {
	// 从配置文件加载设置并返回配置结构体
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	var config Config
	err = yaml.Unmarshal(data, &config)
	if err != nil {
		return nil, err
	}
	return &config, nil
}
