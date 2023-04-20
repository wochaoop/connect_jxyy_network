@echo off
:: 配置信息
set "callback=dr1003" & rem 回调
set "login_method=1" & rem 登录方法
set "ipv4=" & rem WAN IPV4 地址，可以不指定
set "ipv6=" & rem WAN IPV6 地址，可以不指定
set "mac=000000000000" & rem MAC 地址
set "inlet_ip=192.168.40.2" & rem 登录入口 ip
set "ua=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"

set "account=" & rem 账号，默认是学号
set "password=" & rem 密码，默认是身份证后六位
set "operator=telecom" & rem 账号后缀，电信 telecom，移动 cmcc，联通 unicom

:: 检测是否能访问登录页
curl --connect-timeout 5 -s -A "%ua%" --head "http://%inlet_ip%/" | findstr /r /c:"HTTP/1.[01] [23].." >nul
if not %errorlevel%==0 (
    echo 1111
    exit /b 1
)

:: 检测连接
curl --connect-timeout 5 -A "%ua%" "http://%inlet_ip%/" | findstr /r /c:"Dr.COMWebLoginID_1.htm" >nul
if %errorlevel%==1 (
    curl --connect-timeout 5 -X GET -L -F "name=0MKKey" ^
    --referer "http://%inlet_ip%/" ^
    -A "%ua%" ^
    "http://%inlet_ip%:801/eportal/portal/login?callback=%callback%&login_method=%login_method%&user_account=,0,%account%@%operator%&user_password=%password%&wlan_user_ip=%ipv4%&wlan_user_ipv6=%ipv6%&wlan_user_mac=%mac%&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.2&terminal_type=1&lang=zh-cn&v=6692&lang=zh"
    exit /b
)

exit /b
