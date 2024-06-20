# connect_jxyy_network

自动连接 江西应用技术职业学院 寝室的 校园网

目前在 20 栋的 Dr.COM EPortal 的登录系统中测试通过

本程序永远都不会提供任何违反法律法规以及任何破坏网络安全的功能，这个程序只是一个解放双手的工具，解决每次都要手动登录校园网的繁琐步骤，不会对网络安全造成任何威胁

目前最新的是 Go 语言版本，使用前请复制`config_example.yaml`到可执行文件目录下的`config.yaml`，然后根据提示填进去就可以了

搓这个程序最初是为了 最小硬件开销 以及 最大硬件兼容性，前人的方案要么是 curl 命令要么是 OpenWrt 插件，或者 Python 脚本，硬件开销都太大了点，所以我就搓了这个 Go 语言的程序，Go 最大的优势就是编译后的程序体积小，而且不依赖于系统库，所以可以在很多系统上运行

实验性：Rust 版本，请另见 [rust](https://github.com/wochaoop/connect_jxyy_network/tree/rust) 分支

> [!NOTE]
> 学长要毕业跑路啦， ~~现在急需接盘侠，~~ 后续维护可以发起 PR 或者 Issue

## 快速开始

1. 去 [Releases](https://github.com/wochaoop/connect_jxyy_network/releases) 下载对应系统架构的压缩包
2. 解压这个文件
3. 切换到与配置文件相同的目录
4. 创建并编辑`config.yaml`配置文件（也可以通过其他方式上传配置文件）

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

参数示例：

```bash
# 指定配置文件的路径
./connect_jxyy_network -config ./config.yaml
```

### 开机自启

若要开机自启，有以下几种方法可供选择

#### 使用 Systemd 的 init 系统

对于使用了 systemd 的操作系统，推荐使用此方法

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

#### 使用 OpenRC 的 init 系统

对于使用 service 命令的操作系统发行版上，推荐使用这种方法

新建`/etc/init.d/connect_jxyy_network`脚本文件

编辑这个脚本文件：

```bash
#!/bin/sh /etc/rc.common

START=90
STOP=10

SERVICE_NAME="connect_jxyy_network"
SERVICE_PATH="/root/$SERVICE_NAME"
CONFIG_PATH="/root/config.yaml"

start() {
    echo "Starting $SERVICE_NAME service..."
    nohup $SERVICE_PATH -config=$CONFIG_PATH >/dev/null 2>&1 &
}

stop() {
    echo "Stopping $SERVICE_NAME service..."
    killall -q "$SERVICE_PATH"
}

restart() {
    $0 stop
    sleep 1
    $0 start
}

status() {
    pgrep -f "$SERVICE_PATH -config $CONFIG_PATH" > /dev/null
    if [ $? -eq 0 ]; then
        echo "$SERVICE_NAME service is running."
    else
        echo "$SERVICE_NAME service is not running."
    fi
}

reload() {
    echo "Reloading $SERVICE_NAME service..."
    $0 stop
    $0 start
}
```

授予执行权限：

```bash
chmod +x /etc/init.d/connect_jxyy_network
```

启用服务：

```bash
service connect_jxyy_network start
```

开机自启这个服务：
```bash
service connect_jxyy_network enable
```

管理服务

```bash
service connect_jxyy_network stop    # 停止服务
service connect_jxyy_network restart # 重启服务
```

这样，你的服务就会使用service命令进行管理，可以在系统启动时自动运行，也可以手动启动、停止和重启

请确保脚本中的路径和命令是正确的，以便服务能够正常启动和运行

#### 使用 launchctl 工具添加启动项

对于 macOS 系统，推荐使用这种方法

新建`/Library/LaunchDaemons/connect_jxyy_network.plist`配置文件

写入以下内容：（/your/path 应该替换为你实际存放的位置）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>connect_jxyy_network</string>
    <key>ProgramArguments</key>
    <array>
        <string>/your/path/connect_jxyy_network</string>
        <string>-config</string>
        <string>/your/path/config.yaml</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
```

检查plist语法是否正确
```zsh
plutil /Library/LaunchDaemons/connect_jxyy_network.plist
```

修改文件权限
```zsh
chmod 644 /Library/LaunchDaemons/connect_jxyy_network.plist
```

添加自启动项
```zsh
launchctl load /Library/LaunchDaemons/connect_jxyy_network.plist
```

启动自启动项
```zsh
launchctl start connect_jxyy_network.plist
```

删除自启动项：
```zsh
launchctl unload /Library/LaunchDaemons/connect_jxyy_network.plist
```

#### 使用`/etc/rc.local`文件

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

#### 使用 nohup 命令

对于不支持 init 系统的 Linux/Unix 操作系统，推荐使用此方法

```bash
nohup /root/connect_jxyy_network -config=/root/config.yaml >/dev/null 2>&1 &
```

这样，程序将在后台运行，即使退出终端也不会停止，但是重启系统后需要重新运行这个命令

#### 使用 winsw

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
    <log mode="none"/>
</service>
```

安装服务：

- 打开命令提示符或PowerShell，并使用管理员权限运行。
- 运行以下命令安装服务：

```bat
.\winsw.exe install winsw.xml
```

到这里就已经完成了安装服务，下一次重启就能开机自启了

启动服务：

- 运行以下命令立即启动服务：

```bat
.\winsw.exe start winsw.xml
```

如果一切正常，在`Windows 服务`能看到这个服务：
![Windows 服务](docs/images/屏幕截图%202023-10-16%20150555.png)

#### 使用 Docker

如果操作系统安装了 docker ，则可以尝试这个方式

```bash
docker run -d --restart=always \
--pull=always \
--name=connect_jxyy_network \
-v ${PWD}/config.yaml:/app/config.yaml \
ghcr.io/wochaoop/connect_jxyy_network:latest
```

指定`--restart`以实现开机自启

## 支持的系统和架构

目前支持了如下系统、平台和架构

`aix-ppc64`
`android-arm64`
`darwin-amd64`
`darwin-arm64`
`dragonfly-amd64`
`freebsd-386`
`freebsd-amd64`
`freebsd-arm`
`freebsd-arm64`
`freebsd-riscv64`
`illumos-amd64`
`ios-amd64`
`ios-arm64`
`js-wasm`
`linux-386`
`linux-amd64`
`linux-arm`
`linux-arm64`
`linux-loong64`
`linux-mips`
`linux-mips64`
`linux-mips64le`
`linux-mipsle`
`linux-ppc64`
`linux-ppc64le`
`linux-riscv64`
`linux-s390x`
`netbsd-386`
`netbsd-amd64`
`netbsd-arm`
`netbsd-arm64`
`openbsd-386`
`openbsd-amd64`
`openbsd-arm`
`openbsd-arm64`
`openbsd-ppc64`
`plan9-386`
`plan9-amd64`
`plan9-arm`
`solaris-amd64`
`wasip1-wasm`
`windows-386`
`windows-amd64`
`windows-amd64-v3`
`windows-arm64`
`windows-armv7`


如果您的系统和架构不在上面的列表中，您可以尝试自行编译

愿意折腾的话，可以自行尝试动态链接库的方式编译，这样可以减小体积

[Releases](https://github.com/wochaoop/connect_jxyy_network/releases) 中的文件是静态链接的，体积较大，不过通用性较好

## 使用其它的程序

如果上面的 Go 程序不适合您的操作系统，那么您可以尝试我们的旧版方案：

我们在 [其他版本/](其他版本/) 中归档了旧版方案

那个`bat`脚本编辑一下配置就可以在 Windows 系统用了，没有做自动检测，但可以利用计划任务实现自动联网

`sh`脚本用在 Linux/Unix 系统上 ~~（废话）~~ ,结合 crontab 就可以实现全自动联网，解放双手

对于某些类Unix系统，可能旧的`sh`脚本会有问题，可以尝试使用新的 Go 版本 的程序

理论上 dr.com 的网关系统都可以，这个脚本使用的是 GET 方法提交 ~~(POST方法应该也行？但我试了无效，也许别的学校可以？)~~

其实还可以写成 python 脚本的，但毕竟我是塞 OpenWrt 系统里用的，我的 Redmi AC2100 路由器是 mips32 的架构，本身才 128M 内存，
python 本身只能阉割版的，我懒得弄了

~~还是 shell 脚本比较通用~~

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

## 参考文献

- [Dr.COM校园网多设备解决方案——路由器 Padavan/LuCI 固件自动网页认证+Telegram Bot 定时发送连接情况 - 老虎豆](https://tiger.fail/archives/drcom-autologin-padavan-tgbot.html)
- [drcoms/drcom-generic: Dr.COM/DrCOM 现已覆盖 d p x三版。](https://github.com/drcoms/drcom-generic)
- [教你如何在Drcom下使用路由器上校园网(以广东工业大学、极路由1S HC5661A为例) - 云外孤鸟 - 博客园](https://www.cnblogs.com/cloudbird/p/10406936.html)
- (https://www.right.com.cn/forum/thread-215978-1-1.html)
- https://zhuanlan.zhihu.com/p/63085260
- https://gist.github.com/binsee/4dfddb6b1be2803396250b7772056f1c
- http://www.manongjc.com/detail/25-tfxssayypwvtqzm.html
- https://th0masxu.com/index.php/archives/322
