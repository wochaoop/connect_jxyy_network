# connect_jxyy_network
自动连接 江西应用技术职业学院 寝室的 校园网

目前在20栋的 dr.com 的登录系统中测试通过

理论上dr.com的网关系统都可以，这个脚本使用的是GET方法提交 ~~(POST方法应该也行？但我试了无效)~~

其实还可以写成python脚本的，但毕竟我是塞OpenWrt系统里用的，我的Redmi AC2100路由器是mips32的架构，本身才128M内存，python本身只能阉割版的，我懒得弄了

还是shell脚本比较通用

## 截图
![测速截图](images/%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE_20221025_152201.png)
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
