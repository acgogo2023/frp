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
read -p "Please enter the server address (server_addr) [服务端的IP]: " SERVER_ADDR
read -p "Please enter the server port (server_port) [默认7000]: " SERVER_PORT

# 如果用户没有输入server_port，使用默认值7000
if [ -z "$SERVER_PORT" ]; then
  SERVER_PORT=7000
fi

# 提示用户输入local_port和remote_port
read -p "Please enter the local port (local_port): " LOCAL_PORT
read -p "Please enter the remote port (remote_port): " REMOTE_PORT

# 更新frpc.toml文件
cat > frpc.toml <<EOL
[common]
server_addr = $SERVER_ADDR
server_port = $SERVER_PORT

[http_proxy]
type = tcp
plugin = http_proxy
local_ip = 127.0.0.1
local_port = $LOCAL_PORT
remote_port = $REMOTE_PORT
EOL

# 提示用户配置完成
echo "FRP configuration is complete."

# 提示用户是否运行FRP
read -p "Do you want to start FRP now? (yes/no): " RUN_FRP

if [ "$RUN_FRP" = "yes" ]; then
  ./frpc -c ./frpc.toml
else
  echo "You can start FRP later using the following command:"
  echo "./frpc -c ./frpc.toml"
fi
