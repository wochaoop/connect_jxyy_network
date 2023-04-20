#!/bin/sh

# crontab 定时任务
# 每分钟测试校园网络连接，断开时反复尝试连接，需要 curl（假设我放在了 /root 目录下）
# */1 * * * * /root/connect_jxyy_network.sh

# 单次运行
# sh connect_jxyy_network.sh

# 配置信息
callback='dr1003';# 回调
login_method='1';# 登录方法
ipv4='';# WAN IPV4 地址，可以不指定
ipv6='';# WAN IPV6 地址，可以不指定
mac='000000000000';# MAC 地址
inlet_ip='192.168.40.2';# 登录入口 ip
ua='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36'

account='';#账号，默认是学号
password='';#密码，默认是身份证后六位
operator="telecom";# 账号后缀，电信 telecom，移动 cmcc，联通 unicom

# 检测是否能访问登录页
return_value="$(curl --connect-timeout 5 -s -A "${ua}" --head "http://${inlet_ip}/" | head -n 1 | grep "HTTP/1.[01] [23]..")";
if [ -z "${return_value}" ]
then 
    exit 1;
fi

# 循环检测连接，默认 12 次，每次间隔 5 秒，配合 crontab 1 分钟重复执行即每 5 秒执行一次
attempt=0;
while [ $attempt -lt 12 ]
do
    return_value="$(curl --connect-timeout 5 -A "${ua}" "http://${inlet_ip}/" | grep 'Dr.COMWebLoginID_1.htm')";
    if [ -z "${return_value}" ]
    then
        curl --connect-timeout 5 -X GET -L -F "name=0MKKey" \
        --referer "http://${inlet_ip}/" \
        -A "${ua}" \
        "http://${inlet_ip}:801/eportal/portal/login?callback=${callback}&login_method=${login_method}&user_account=,0,${account}@${operator}&user_password=${password}&wlan_user_ip=${ipv4}&wlan_user_ipv6=${ipv6}&wlan_user_mac=${mac}&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.2&terminal_type=1&lang=zh-cn&v=6692&lang=zh";
        exit 0;
    fi
    let attempt=${attempt}+1;
    sleep 5;
done

exit 0;