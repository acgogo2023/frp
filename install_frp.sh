#!/bin/bash

# 定义文件名
FRP_TAR="frp_0.59.0_linux_amd64.tar.gz"
FRP_DIR="frp_0.59.0_linux_amd64"

# 检查是否已下载FRP文件
if [ ! -f "$FRP_TAR" ]; then
  echo "正在下载 FRP..."
  curl -LO https://github.com/fatedier/frp/releases/download/v0.59.0/$FRP_TAR
else
  echo "FRP 文件已存在，跳过下载步骤。"
fi

# 检查是否已解压FRP文件
if [ ! -d "$FRP_DIR" ]; then
  echo "正在解压 FRP..."
  tar -xzvf $FRP_TAR
else
  echo "FRP 已经解压，跳过解压步骤。"
fi

# 进入FRP目录
cd $FRP_DIR

# 提示用户选择配置和启动FRPC或FRPS
read -p "你想配置和启动 FRPC 还是 FRPS? (输入 'FRPC' 或 'FRPS'): " CHOICE

if [ "$CHOICE" = "FRPC" ]; then
  # 提示用户输入FRPC配置
  read -p "请输入服务器地址 (server_addr) [服务端的IP]: " SERVER_ADDR
  read -p "请输入服务器端口 (server_port) [默认7000]: " SERVER_PORT

  # 如果用户没有输入server_port，使用默认值7000
  if [ -z "$SERVER_PORT" ]; then
    SERVER_PORT=7000
  fi

  # 提示用户输入FRPC的local_port和remote_port
  read -p "请输入 FRPC 本地端口 (local_port): " LOCAL_PORT
  read -p "请输入 FRPC 远程端口 (remote_port): " REMOTE_PORT

  # 提示用户输入 [http_proxy] 名称
  read -p "请输入 [http_proxy] 名称: " HTTP_PROXY_NAME

  # 更新 frpc.toml 文件
  cat > frpc.toml <<EOL
[common]
server_addr = $SERVER_ADDR
server_port = $SERVER_PORT
log_file = "frpc.log"
log_level = "info"
log_max_days = 1

[$HTTP_PROXY_NAME]
type = tcp
plugin = http_proxy
local_ip = 127.0.0.1
local_port = $LOCAL_PORT
remote_port = $REMOTE_PORT
EOL

  # 提示用户配置完成
  echo "FRPC 配置完成。"

  # 提示用户是否启动FRPC
  read -p "你要现在启动 FRPC 吗? (yes/no): " RUN_FRPC

  if [ "$RUN_FRPC" = "yes" ];then
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

elif [ "$CHOICE" = "FRPS" ]; then
  # 提示用户输入FRPS配置
  read -p "请输入 FRPS 监听端口 (bind_port) [默认7000]: " FRPS_PORT

  # 如果用户没有输入FRPS端口，使用默认值7000
  if [ -z "$FRPS_PORT" ];then
    FRPS_PORT=7000
  fi

  # 提示用户输入FRPS的账户和密码
  read -p "请输入 FRPS 账户 (auth_user): " AUTH_USER
  read -sp "请输入 FRPS 密码 (auth_pass): " AUTH_PASS
  echo # 换行

  # 更新 frps.toml 文件
  cat > frps.toml <<EOL
[common]
bind_addr = 0.0.0.0
bind_port = $FRPS_PORT
log_file = "frps.log"
log_level = "info"
log_max_days = 1

[auth]
auth_user = $AUTH_USER
auth_pass = $AUTH_PASS
EOL

  # 提示用户配置完成
  echo "FRPS 配置完成。"

  # 提示用户是否启动FRPS
  read -p "你要现在启动 FRPS 吗? (yes/no): " RUN_FRPS

  if [ "$RUN_FRPS" = "yes" ];then
    read -p "你要在后台运行 FRPS 吗? (yes/no): " BACKGROUND_FRPS
    if [ "$BACKGROUND_FRPS" = "yes" ];then
      nohup ./frps -c ./frps.toml &
      echo "FRPS 已在后台启动。"
    else
      ./frps -c ./frps.toml
    fi
  else
    echo "你可以稍后使用以下命令启动 FRPS:"
    echo "./frps -c ./frps.toml"
  fi

else
  echo "无效的选择，请重新运行脚本并输入 'FRPC' 或 'FRPS'。"
fi
