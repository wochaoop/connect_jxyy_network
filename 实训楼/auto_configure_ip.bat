@echo off

setlocal enabledelayedexpansion

REM ����IP��ַ��Χ
for /L %%i in (2,1,254) do (
    echo ���ڳ������� IP ��ַ: 192.168.31.%%i

    REM ���þ�̬IP��ַ����������
    netsh interface ip set address name="��̫��" source="static" addr="192.168.31.%%i" mask="255.255.255.0" gateway="192.168.31.1" gwmetric=1

    echo �������ã����Եȡ���

    REM �ȴ�һ��ʱ����ȷ������������Ч
    timeout /t 5 /nobreak >nul

    REM ����DNS������
    netsh interface ip set dns name="��̫��" source="static" addr="192.168.31.1" register=PRIMARY

    REM �ȴ�һ��ʱ����ȷ������������Ч
    timeout /t 5 /nobreak >nul

    REM ����Ƿ���� ping ͨ�ٶ�
    ping -n 1 baidu.com | find "TTL=" >nul
    if not errorlevel 1 (
        echo ������������ɣ�
        pause
        exit /b
    )
)

echo �޷����ӻ������������������ӻ����IP��ַ��Χ��
pause
