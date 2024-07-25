#!/bin/bash

# 下载FRP最新版本
echo "正在下载 FRP..."
curl -LO https://github.com/fatedier/frp/releases/download/v0.59.0/frp_0.59.0_linux_amd64.tar.gz

# 解压文件
echo "正在解压 FRP..."
tar -xzvf frp_0.59.0_linux_amd64.tar.gz

# 移动到FRP目录
cd frp_0.59.0_linux_amd64

# 提示用户输入server_addr
read -p "请输入服务器地址 (server_addr) [服务端的IP]: " SERVER_ADDR
read -p "请输入服务器端口 (server_port) [默认7000]: " SERVER_PORT

# 如果用户没有输入server_port，使用默认值7000
if [ -z "$SERVER_PORT" ]; then
  SERVER_PORT=7000
fi

# 提示用户输入local_port和remote_port
read -p "请输入本地端口 (local_port): " LOCAL_PORT
read -p "请输入远程端口 (remote_port): " REMOTE_PORT

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
echo "FRP 配置完成。"

# 提示用户是否启动FRP
read -p "你要现在启动 FRPC 吗? (yes/no): " RUN_FRPC
read -p "你要现在启动 FRPS 吗? (yes/no): " RUN_FRPS

# 提示用户是否在后台运行FRPC
if [ "$RUN_FRPC" = "yes" ]; then
  read -p "你要在后台运行 FRPC 吗? (yes/no): " BACKGROUND_FRPC
  if [ "$BACKGROUND_FRPC" = "yes" ]; then
    nohup ./frpc -c ./frpc.toml &
    echo "FRPC 已在后台启动。"
  else
    ./frpc -c ./frpc.toml
  fi
else
  echo "你可以稍后使用以下命令启动 FRPC:"
  echo "./frpc -c ./frpc.toml"
fi

# 提示用户是否在后台运行FRPS
if [ "$RUN_FRPS" = "yes" ]; then
  read -p "你要在后台运行 FRPS 吗? (yes/no): " BACKGROUND_FRPS
  if [ "$BACKGROUND_FRPS" = "yes" ]; then
    nohup ./frps -c ./frps.toml &
    echo "FRPS 已在后台启动。"
  else
    ./frps -c ./frps.toml
  fi
else
  echo "你可以稍后使用以下命令启动 FRPS:"
  echo "./frps -c ./frps.toml"
fi
