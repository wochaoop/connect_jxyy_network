# connect_jxyy_network

自动连接 江西应用技术职业学院 寝室的 校园网

目前在 20 栋的 Dr.COM EPortal 的登录系统中测试通过

目前最新的是 Go 语言版本，使用前请复制`config_example.yaml`到可执行文件目录下的`config.yaml`，然后根据提示填进去就可以了

## 快速开始

### 使用Go 语言的程序

1. 去 [Releases](https://github.com/wochaoop/connect_jxyy_network/releases) 下载对应架构的压缩包
2. 解压这个文件
3. 切换到与配置文件相同的目录
4. 创建并编辑`config.yaml`配置文件

```yaml
# 以下是配置信息

# 账号，默认是学号
account: ''
# 密码，默认是身份证后六位
password: ''
# 账号运营商，电信 telecom，移动 cmcc，联通 unicom
operator: 'telecom'

# 上面的配置是主要的

# 回调
callback: 'dr1003'
# 登录方法
login_method: '1'
# WAN IPV4 地址，可以不指定
ipv4: ''
# WAN IPV6 地址，可以不指定
ipv6: ''
# MAC 地址
mac: '000000000000'
# 登录入口 ip
inlet_ip: '192.168.40.2'
# User-Agent, 一般不用改
ua: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36'
# 最大尝试次数
max_attempts: 12
# 尝试延迟时间(秒)
attempt_delay: 5
# 是否只执行一次，即不要死循环
only_once: false
```

5. 直接运行可执行文件，可以指定参数

参数示例

```bash
# 指定配置文件的路径
./connect_jxyy_network -config ./config.yaml
```

#### 开机自启

若要开机自启，有以下几种方法可供选择

##### 使用 systemctl

对于使用了 systemctl 工具的操作系统，推荐使用此方法

新建`/usr/lib/systemd/system/connect_jxyy_network.service`配置文件

```bash
[Unit]
Description=connect_jxyy_network service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
ExecStart=/root/connect_jxyy_network -config /root/config.yaml
WorkingDirectory=/root/

[Install]
WantedBy=multi-user.target
```

启用这个配置文件：

`systemctl enable connect_jxyy_network`

使用以上命令，程序将在系统启动时自动启动。如果需要重启应用，可以使用以下命令：

`systemctl restart connect_jxyy_network`

如果要停止应用，可以使用以下命令：

`systemctl stop connect_jxyy_network`

要查看应用的日志，可以使用以下命令：

`systemctl status connect_jxyy_network`

以上路径请根据实际情况修改

##### 使用service命令启动和管理服务
如果是在不使用 systemctl 命令而是使用 service 命令的 Linux/Unix 系统发行版上，推荐使用这种方法

新建`/etc/init.d/connect_jxyy_network`脚本文件

编辑这个脚本文件：

```bash
#!/bin/bash
### BEGIN INIT INFO
# Provides:          connect_jxyy_network
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop:     $network $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start connect_jxyy_network service
### END INIT INFO

case "$1" in
  start)
    echo "Starting connect_jxyy_network service..."
    /root/connect_jxyy_network -config /root/config.yaml &
    ;;
  stop)
    echo "Stopping connect_jxyy_network service..."
    pkill -f "/root/connect_jxyy_network -config /root/config.yaml"
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
```

授予执行权限：

```bash
chmod +x /etc/init.d/connect_jxyy_network
```

启用服务：

```bash
service connect_jxyy_network start
```

管理服务

```bash
service connect_jxyy_network stop    # 停止服务
service connect_jxyy_network restart # 重启服务
```

这样，你的服务就会使用service命令进行管理，可以在系统启动时自动运行，也可以手动启动、停止和重启

请确保脚本中的路径和命令是正确的，以便服务能够正常启动和运行

##### 使用`/etc/rc.local`文件

对于极致精简以及自定义了内核的 Linux/Unix 操作系统，则推荐下面的方式

有时候可以在诸如 OpenWrt、Pandavan 等的路由操作系统的 GUI 界面找到这个配置文件的编辑框

在中间插入`nohup /root/connect_jxyy_network -config=/root/config.yaml >/dev/null 2>&1 &`命令

在文件中的示例：

```bash
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

nohup /root/connect_jxyy_network -config=/root/config.yaml >/dev/null 2>&1 &

exit 0
```

##### 使用winsw

对于 Windows 系统，推荐使用此方法

首先下载`winsw`：

- 访问`winsw`的 GitHub 页面：[winsw](https://github.com/winsw/winsw/releases/latest)
- 下载对应架构的最新版本的`winsw`
- 解压缩下载的`winsw`可执行文件
- 重命名`winsw.exe`并移动到本程序的相同目录中

然后编写`winsw.xml`文件，可以根据需要自行修改

```xml
<service>
    <id>connect_jxyy_network</id>
    <name>connect_jxyy_network</name>
    <description>connect_jxyy_network Service</description>
    <executable>connect_jxyy_network.exe</executable>
    <arguments>-config ./config.yaml</arguments>
    <interactive>false</interactive>
    <startmode>Automatic</startmode>
    <logmode>rotate</logmode>
    <sizeThreshold>64K</sizeThreshold>
    <logFiles>4</logFiles>
</service>
```

安装服务：

- 打开命令提示符或PowerShell，并使用管理员权限运行。
- 运行以下命令安装服务：

```
.\winsw.exe install winsw.xml
```

到这里就已经完成了安装服务，下一次重启就能开机自启了

启动服务：

- 运行以下命令立即启动服务：

```
.\winsw.exe start winsw.xml
```

如果一切正常，在`Windows 服务`能看到这个服务：
![Windows 服务](docs/images/屏幕截图%202023-10-16%20150555.png)

#### 支持的系统和架构

目前支持了如下系统和架构

`darwin-amd64`
`darwin-amd64-v3`
`darwin-arm64`
`freebsd-386`
`freebsd-amd64`
`freebsd-amd64-v3`
`freebsd-arm64`
`linux-386`
`linux-amd64`
`linux-amd64-v3`
`linux-arm64`
`linux-armv5`
`linux-armv6`
`linux-armv7`
`linux-loong64`
`linux-mips-hardfloat`
`linux-mips-softfloat`
`linux-mips64`
`linux-mips64le`
`linux-mipsle-hardfloat`
`linux-mipsle-softfloat`
`linux-riscv64`
`windows-386`
`windows-amd64`
`windows-amd64`
`windows-arm64`
`windows-armv7`

### 使用 Docker

```bash
docker run -d --name=connect_jxyy_network \
-v ${PWD}/config.yaml:/app/config.yaml \
ghcr.io/wochaoop/connect_jxyy_network:latest
```
### 使用其它的程序

那个`bat`脚本编辑一下配置就可以在 Windows 系统用了，没有做自动检测，但可以利用计划任务实现自动联网

`sh`脚本用在 Linux 系统上 ~~（废话）~~ ,结合 crontab 就可以实现全自动联网，解放双手

理论上 dr.com 的网关系统都可以，这个脚本使用的是 GET 方法提交 ~~(POST方法应该也行？但我试了无效，也许别的学校可以？)~~

其实还可以写成 python 脚本的，但毕竟我是塞 OpenWrt 系统里用的，我的 Redmi AC2100 路由器是 mips32 的架构，本身才 128M 内存，
python 本身只能阉割版的，我懒得弄了

还是 shell 脚本比较通用

## 截图

- 测速
  ![测速截图](docs/images/屏幕截图_20221025_152201.png)
  ![测速截图](docs/images/屏幕截图_20221102_233538.png)
  ![测速截图](docs/images/屏幕截图_20221105_184211.png)
- Pandavan
  ![截图](docs/images/屏幕截图_20221102_233238.png)
- OpenWrt
  -
    - 记得配置一下防火墙 ~~（要不然被连上路由器的贱人给断网了）~~
      ![](docs/images/屏幕截图%202023-04-02%20114744.png)
      ![](docs/images/屏幕截图%202023-04-02%20115446.png)
      ![](docs/images/屏幕截图%202023-04-02%20115553.png)

## 参考文献：

- [Dr.COM校园网多设备解决方案——路由器 Padavan/LuCI 固件自动网页认证+Telegram Bot 定时发送连接情况 - 老虎豆](https://tiger.fail/archives/drcom-autologin-padavan-tgbot.html)
- [drcoms/drcom-generic: Dr.COM/DrCOM 现已覆盖 d p x三版。](https://github.com/drcoms/drcom-generic)
- [教你如何在Drcom下使用路由器上校园网(以广东工业大学、极路由1S HC5661A为例) - 云外孤鸟 - 博客园](https://www.cnblogs.com/cloudbird/p/10406936.html)
- (https://www.right.com.cn/forum/thread-215978-1-1.html)
- https://zhuanlan.zhihu.com/p/63085260
- https://gist.github.com/binsee/4dfddb6b1be2803396250b7772056f1c
- http://www.manongjc.com/detail/25-tfxssayypwvtqzm.html
- https://th0masxu.com/index.php/archives/322
