package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
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
	// 从配置文件加载配置
	config, err := loadConfig("config.yaml")
	if err != nil {
		fmt.Printf("[%s] 读取配置文件失败: %v\n", currentTime(), err)
		return
	}

	// 创建 HTTP 客户端
	client := http.Client{Timeout: 5 * time.Second}

	// 决定是否需要循环执行
	shouldRunLoop := !config.OnlyOnce

	// 主循环
	for shouldRunLoop {
		// 检查是否能够访问登录页面
		resp, err := client.Head(fmt.Sprintf("http://%s/", config.InletIP))
		if err != nil || (resp.StatusCode < 200 || resp.StatusCode >= 300) {
			logMessage("无法访问登录页面")
			sleep(config.AttemptDelay)
			continue
		}

		// 尝试登录
		attempt := 0
		for attempt < config.MaxAttempts {
			resp, err := client.Get(fmt.Sprintf("http://%s/", config.InletIP))
			if err != nil || resp.StatusCode != http.StatusOK {
				logMessage("找不到登录页面")
				sleep(config.AttemptDelay)
				continue
			}
			if !containsSubstring(readResponseBody(resp.Body), "Dr.COMWebLoginID_1.htm") {
				loginURL := fmt.Sprintf("http://%s:801/eportal/portal/login?callback=%s&login_method=%s&user_account=0,%s@%s&user_password=%s&wlan_user_ip=&wlan_user_ipv6=&wlan_user_mac=&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.2&terminal_type=1&lang=zh-cn&v=6692&lang=zh", config.InletIP, config.Callback, config.LoginMethod, config.Account, config.Operator, config.Password)
				if _, err := client.Get(loginURL); err != nil {
					logMessage(fmt.Sprintf("登录时出现错误: %v", err))
					sleep(config.AttemptDelay)
					continue
				}
				logMessage("登录成功")
				sleep(config.AttemptDelay)
				continue
			}
			attempt++
			sleep(config.AttemptDelay)
		}

		// 根据配置决定是否继续循环
		shouldRunLoop = !config.OnlyOnce
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

func containsSubstring(str, substr string) bool {
	// 检查一个字符串是否包含另一个子字符串
	return len(str) >= len(substr) && str[len(str)-len(substr):] == substr
}

func readResponseBody(body io.ReadCloser) string {
	// 读取响应的内容并返回字符串
	defer func(body io.ReadCloser) {
		_ = body.Close()
	}(body)

	tmpFile, err := os.CreateTemp("", "response")
	if err != nil {
		fmt.Println("创建临时文件时出现错误:", err)
		return ""
	}
	defer func(name string) {
		_ = os.Remove(name)
	}(tmpFile.Name())

	_, err = io.Copy(tmpFile, body)
	if err != nil {
		fmt.Println("将响应体复制到文件时出现错误:", err)
		return ""
	}

	content, err := os.ReadFile(tmpFile.Name())
	if err != nil {
		fmt.Println("读取临时文件时出现错误:", err)
		return ""
	}

	return string(content)
}
