@echo off

setlocal enabledelayedexpansion

REM 遍历IP地址范围
for /L %%i in (2,1,254) do (
    echo 正在尝试配置 IP 地址: 192.168.31.%%i

    REM 设置静态IP地址和子网掩码
    netsh interface ip set address name="以太网" source="static" addr="192.168.31.%%i" mask="255.255.255.0" gateway="192.168.31.1" gwmetric=1

    echo 正在配置，请稍等……

    REM 等待一段时间以确保网络配置生效
    timeout /t 5 /nobreak >nul

    REM 设置DNS服务器
    netsh interface ip set dns name="以太网" source="static" addr="192.168.31.1" register=PRIMARY

    REM 等待一段时间以确保网络配置生效
    timeout /t 5 /nobreak >nul

    REM 检查是否可以 ping 通百度
    ping -n 1 baidu.com | find "TTL=" >nul
    if not errorlevel 1 (
        echo 网络配置已完成！
        pause
        exit /b
    )
)

echo 无法连接互联网，请检查网络连接或更改IP地址范围。
pause
