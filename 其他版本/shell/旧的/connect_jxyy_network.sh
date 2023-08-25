#!/bin/sh

# crontab定时任务

# 每分钟测试校园网络连接，断开时反复尝试连接，需要curl（假设我放在了/root目录下）
# */1 * * * * /root/connect_jxyy_network.sh
# 单次运行
# sh connect_jxyy_network.sh

#配置信息
callback='dr1003';#运营商信息，dr1003为电信
login_method='1';
ipv4='';#WAN IPV4地址，可以不指定
ipv6='';#WAN IPV6地址，可以不指定
mac='000000000000';
inlet_ip='192.168.40.2';#登录入口ip
account='';#账号，即学号
password='';#密码，即身份证后六位

return1="$(ping www.baidu.com -c 1 | tail -n 1 | grep 'min')";

if [ -z "$return1" ]
then
    curl -X GET -L -F 'name=0MKKey' \
    --referer "http://${inlet_ip}/" \
    -H 'Accept: */*' \
    -H 'Content-Type: text/html; charset=utf-8' \
    -H 'Accept-Language: zh-CN,zh;q=0.9' \
    -H 'Connection: keep-alive' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36' \
    "http://${inlet_ip}:801/eportal/portal/login?callback=${callback}&login_method=${login_method}&user_account=,0,${account}@telecom&user_password=${password}&wlan_user_ip=${ipv4}&wlan_user_ipv6=${ipv6}&wlan_user_mac=${mac}&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.2&terminal_type=1&lang=zh-cn&v=6692&lang=zh";
fi

exit 0