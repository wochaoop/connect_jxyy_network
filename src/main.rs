use std::fs::File;
use std::io::prelude::*;
use std::time::Duration;
use std::thread::sleep;
use serde::{Deserialize, Serialize};
use reqwest::Client;
use url::Url;

#[derive(Debug, Serialize, Deserialize)]
struct Config {
    callback: String,
    login_method: String,
    ipv4: String,
    ipv6: String,
    mac: String,
    inlet_ip: String,
    ua: String,
    account: String,
    password: String,
    operator: String,
    max_attempts: i32,
    attempt_delay: i32,
    only_once: bool,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = load_config("./config.yaml")?;

    let client = Client::new();

    loop {
        let resp = client.get(format!("http://{}/", config.inlet_ip)).send().await;

        match resp {
            Ok(resp) => {
                if resp.status().is_success() {
                    let body = resp.text().await?;

                    if body.contains("Dr.COMWebLoginID_0.htm") {
                        let login_url = format!("http://{}:801/eportal/portal/login", config.inlet_ip);
                        let login_params = vec![
                            format!("callback={}", config.callback),
                            format!("login_method={}", config.login_method),
                            format!("user_account=,0,{}@{}", config.account, config.operator),
                            format!("user_password={}", config.password),
                            format!("wlan_user_ip={}", config.ipv4),
                            format!("wlan_user_ipv6={}", config.ipv6),
                            format!("wlan_user_mac={}", config.mac),
                        ];
                        let login_url_with_params = format!("{}?{}", login_url, login_params.join("&"));

                        let login_result = client.get(Url::parse(&login_url_with_params)?).send().await;

                        match login_result {
                            Ok(_) => println!("Login successful"),
                            Err(e) => println!("Error occurred during login: {}", e),
                        }
                    }
                }
            }
            Err(e) => println!("Error occurred during request: {}", e),
        }

        sleep(Duration::from_secs(config.attempt_delay as u64));
    }
}

fn load_config(filename: &str) -> Result<Config, Box<dyn std::error::Error>> {
    let mut file = File::open(filename)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    let config: Config = serde_yaml::from_str(&contents)?;
    Ok(config)
}