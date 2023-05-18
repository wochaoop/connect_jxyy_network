# connect_jxyy_network
自动连接 江西应用技术职业学院 寝室的 校园网

目前在20栋的 dr.com 的登录系统中测试通过

那个`bat`脚本编辑一下配置就可以在 Windows 系统用了，没有做自动检测，但可以利用计划任务实现自动联网

`sh`脚本用在 Linux 系统上 ~~（废话）~~ ,结合 crontab 就可以实现全自动联网，解放双手

理论上 dr.com 的网关系统都可以，这个脚本使用的是 GET 方法提交 ~~(POST方法应该也行？但我试了无效，也许别的学校可以？)~~

其实还可以写成 python 脚本的，但毕竟我是塞 OpenWrt 系统里用的，我的 Redmi AC2100 路由器是 mips32 的架构，本身才 128M 内存， python 本身只能阉割版的，我懒得弄了

还是 shell 脚本比较通用

## 截图
![测速截图](images/屏幕截图_20221025_152201.png)
![测速截图](images/屏幕截图_20221102_233538.png)
![测速截图](images/屏幕截图_20221105_184211.png)

## 参考文献：

- [Dr.COM校园网多设备解决方案——路由器 Padavan/LuCI 固件自动网页认证+Telegram Bot 定时发送连接情况 - 老虎豆](https://tiger.fail/archives/drcom-autologin-padavan-tgbot.html)
- [drcoms/drcom-generic: Dr.COM/DrCOM 现已覆盖 d p x三版。](https://github.com/drcoms/drcom-generic)
- [教你如何在Drcom下使用路由器上校园网(以广东工业大学、极路由1S HC5661A为例) - 云外孤鸟 - 博客园](https://www.cnblogs.com/cloudbird/p/10406936.html)
- (https://www.right.com.cn/forum/thread-215978-1-1.html)
- https://zhuanlan.zhihu.com/p/63085260
- https://gist.github.com/binsee/4dfddb6b1be2803396250b7772056f1c
- http://www.manongjc.com/detail/25-tfxssayypwvtqzm.html
- https://th0masxu.com/index.php/archives/322
