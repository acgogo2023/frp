#!/bin/bash

# 下载FRP最新版本
echo "Downloading FRP..."
curl -LO https://github.com/fatedier/frp/releases/download/v0.59.0/frp_0.59.0_linux_amd64.tar.gz

# 解压文件
echo "Extracting FRP..."
tar -xzvf frp_0.59.0_linux_amd64.tar.gz

# 移动到FRP目录
cd frp_0.59.0_linux_amd64

# 提示用户输入server_addr
read -p "Please enter the server address (server_addr): " SERVER_ADDR
read -p "Please enter the server port (server_port): " SERVER_PORT

# 更新frpc.toml文件
cat > frpc.toml <<EOL
[common]
server_addr = $SERVER_ADDR
server_port = $SERVER_PORT

[http_proxy]
type = tcp
plugin = http_proxy
local_ip = 127.0.0.1
local_port = 5269
remote_port = 5269
EOL

# 提示用户配置完成
echo "FRP configuration is complete. You can start FRP using the following command:"
echo "./frpc -c ./frpc.toml"
