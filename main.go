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
	// Define command-line flags
	configFile := flag.String("config", "./config.yaml", "配置文件的路径")
	flag.Parse()

	config, err := loadConfig(*configFile)
	if err != nil {
		fmt.Printf("[%s] 读取配置文件失败: %v\n", currentTime(), err)
		return
	}

	client := http.Client{Timeout: 5 * time.Second}
	shouldRunLoop := !config.OnlyOnce

	for shouldRunLoop {
		resp, err := client.Get(fmt.Sprintf("http://%s/", config.InletIP))
		if err != nil || (resp.StatusCode < 200 || resp.StatusCode >= 300) {
			logMessage("无法访问登录页面")
			sleep(config.AttemptDelay)
			continue
		}

		body, err := io.ReadAll(resp.Body)
		_ = resp.Body.Close()

		if err != nil {
			logMessage("无法读取响应体")
			sleep(config.AttemptDelay)
			continue
		}

		responseBody := string(body)

		if strings.Contains(responseBody, "Dr.COMWebLoginID_1.htm") {
			logMessage("已经在线")
		} else if strings.Contains(responseBody, "Dr.COMWebLoginID_0.htm") {
			loginURL := fmt.Sprintf("http://%s:801/eportal/portal/login", config.InletIP)
			loginURLWithParams := fmt.Sprintf("%s?name=0MKKey&callback=%s&login_method=%s&user_account=,0,%s@%s&user_password=%s&wlan_user_ip=%s&wlan_user_ipv6=%s&wlan_user_mac=%s&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.2&terminal_type=1&lang=zh-cn&v=6692&lang=zh",
				loginURL, config.Callback, config.LoginMethod, config.Account, config.Operator, config.Password, config.IPv4, config.IPv6, config.MAC)
			resp, err := client.Get(loginURLWithParams)
			if err != nil {
				logMessage(fmt.Sprintf("登录时出现错误: %v", err))
			} else {
				err := resp.Body.Close()
				if err != nil {
					return
				}
				logMessage("登录成功")
			}
		} else {
			logMessage("找不到登录页面")
		}

		sleep(config.AttemptDelay)
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
