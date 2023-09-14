package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"
)

type Config struct {
	Callback     string
	LoginMethod  string
	IPv4         string
	IPv6         string
	MAC          string
	InletIP      string
	UserAgent    string
	Account      string
	Password     string
	Operator     string
	MaxAttempts  int
	AttemptDelay int
	OnlyOnce     bool
}

func main() {
	config := &Config{
		Callback:     "dr1003",
		LoginMethod:  "1",
		IPv4:         "",
		IPv6:         "",
		MAC:          "000000000000",
		InletIP:      "192.168.40.2",
		UserAgent:    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36",
		Account:      "",
		Password:     "",
		Operator:     "telecom",
		MaxAttempts:  12,
		AttemptDelay: 5,
		OnlyOnce:     false,
	}

	client := &http.Client{Timeout: 5 * time.Second} // Reuse HTTP client

	loginIfNeeded(config, client)
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
						fmt.Printf(fmt.Sprintf("登录时出现错误: %v", err))
					} else {
						fmt.Printf("登录成功")
					}
				}
			}
		}

		time.Sleep(time.Duration(config.AttemptDelay) * time.Second)
	}
}
