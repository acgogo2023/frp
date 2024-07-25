#!/bin/bash

# 下载正向补给燃料区（同forward refueling area）最新版本
回声"正在下载FRP ... "
卷曲-你好https://github . com/fate dier/FRP/releases/download/v 0 . 59 . 0/FRP _ 0 . 59 . 0 _ Linux _ amd64 . tar . gz

# 解压文件
回声"提取纤维增强塑料..."
水手-xzvffrp_0.59.0_linux_amd64.tar.gz

# 移动到正向补给燃料区（同forward refueling area）目录
cd frp_0.59.0_linux_amd64

# 提示用户输入服务器地址
阅读-p "请输入服务器地址(server_addr):"服务器_ADDR
阅读-p "请输入服务器端口(服务器端口): "服务器端口

# 更新frpc.toml文件
cat > frpc.toml<<EOL
[常见]
服务器地址= $服务器addr
服务器端口= $服务器端口

[http_proxy]
类型= tcp
插件= http _代理
local_ip = 127.0.0.1
本地端口= 5269
远程端口= 5269
寿命终止

# 提示用户配置完成
回声“玻璃钢配置完成。您可以使用以下命令启动FRP:"
回声"./frpc -c ./frpc.toml "
