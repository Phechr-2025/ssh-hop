#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'

mkdir -p /usr/local/bin/
mkdir -p /etc/shadowsocks
rm -rf /usr/bin/shadowhost
cd /usr/bin
wget -O addss-p "https://raw.githubusercontent.com/Phechr-2025/ssh-hop/main/shadowsocks-plugin/addss-p.sh"
chmod +x addss-p
wget -O delss "https://raw.githubusercontent.com/Phechr-2025/ssh-hop/main/shadowsocks/delss.sh"
cd
MYIP=$(wget -qO- ipinfo.io/ip);
clear
domain=$(cat /etc/xray/domain)
apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release tar -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Bangkok
chronyc sourcestats -v
chronyc tracking -v
date
rm -rf /usr/local/bin/v2ray-plugin
rm -rf /usr/local/bin/gost-plugin
rm -rf /usr/local/bin/xray-plugin
cd /usr/bin/
rm -rf xray-plugin
rm -rf v2xray-plugin
rm -rf gost-plugin

latest_asset_url() {
    repo="$1"
    pattern="$2"
    curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" \
        | grep -E '"browser_download_url":' \
        | grep -E "$pattern" \
        | head -n 1 \
        | cut -d '"' -f 4
}

install_plugin_tar() {
    repo="$1"
    pattern="$2"
    binary="$3"
    tmpdir=$(mktemp -d)
    url=$(latest_asset_url "$repo" "$pattern")
    if [ -z "$url" ]; then
        echo "Cannot find release asset for ${repo} matching ${pattern}"
        exit 1
    fi
    curl -fL "$url" -o "$tmpdir/plugin.tar.gz"
    tar -xzf "$tmpdir/plugin.tar.gz" -C "$tmpdir"
    plugin_path=$(find "$tmpdir" -type f -name "$binary" | head -n 1)
    if [ -z "$plugin_path" ]; then
        echo "Cannot find ${binary} inside ${url}"
        exit 1
    fi
    install -m 755 "$plugin_path" "/usr/bin/${binary}"
    rm -rf "$tmpdir"
}

download_latest_file() {
    repo="$1"
    pattern="$2"
    output="$3"
    url=$(latest_asset_url "$repo" "$pattern")
    if [ -z "$url" ]; then
        echo "Cannot find release asset for ${repo} matching ${pattern}"
        exit 1
    fi
    curl -fL "$url" -o "$output"
}

install_plugin_tar "maskedeken/gost-plugin" "gost-plugin-linux-amd64-.*\\.tar\\.gz" "gost-plugin"
install_plugin_tar "shadowsocks/v2ray-plugin" "v2ray-plugin-linux-amd64-.*\\.tar\\.gz" "v2ray-plugin"
install_plugin_tar "teddysun/xray-plugin" "xray-plugin-linux-amd64-.*\\.tar\\.gz" "xray-plugin"

cd /home/vps/public_html/
download_latest_file "hamid-nazari/ShadowsocksGostPlugin" "ShadowsocksGOSTPlugin-.*release\\.apk" "gost-plugin-android.apk"
download_latest_file "shadowsocks/v2ray-plugin-android" "v2ray--universal-.*\\.apk" "v2ray-plugin-universal.apk"
download_latest_file "teddysun/xray-plugin-android" "xray-plugin-universal-.*\\.apk" "xray-plugin-universal.apk"

sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
