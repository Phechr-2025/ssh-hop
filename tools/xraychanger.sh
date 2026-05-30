#!/bin/bash
set -e

xray_path="/usr/local/bin/xray"
asset_dir="/usr/local/bin"

install_official_latest() {
    apt install -y curl unzip >/dev/null 2>&1 || true
    latest_tag="$(curl -fsSL https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep tag_name | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1)"
    if [ -z "$latest_tag" ]; then
        echo "Cannot detect latest Xray-core release."
        exit 1
    fi

    tmpdir="$(mktemp -d)"
    url="https://github.com/XTLS/Xray-core/releases/download/${latest_tag}/Xray-linux-64.zip"
    curl -fL "$url" -o "$tmpdir/Xray-linux-64.zip"
    unzip -q "$tmpdir/Xray-linux-64.zip" -d "$tmpdir"

    if [ -f "$xray_path" ]; then
        cp "$xray_path" "${xray_path}.bak"
    fi

    install -m 755 "$tmpdir/xray" "$xray_path"
    [ -f "$tmpdir/geoip.dat" ] && install -m 644 "$tmpdir/geoip.dat" "$asset_dir/geoip.dat"
    [ -f "$tmpdir/geosite.dat" ] && install -m 644 "$tmpdir/geosite.dat" "$asset_dir/geosite.dat"
    rm -rf "$tmpdir"

    systemctl restart xray 2>/dev/null || true
    xray version
}

restore_backup() {
    if [ ! -f "${xray_path}.bak" ]; then
        echo "No backup found at ${xray_path}.bak"
        exit 1
    fi
    install -m 755 "${xray_path}.bak" "$xray_path"
    systemctl restart xray 2>/dev/null || true
    xray version
}

clear
echo "Xray-core Changer By Phechr-2025"
echo "1. Install latest official XTLS/Xray-core"
echo "2. Restore previous xray backup"
echo "0. Exit"
read -rp "Select option: " menu

case "$menu" in
    1) install_official_latest ;;
    2) restore_backup ;;
    0) exit 0 ;;
    *) echo "Invalid option"; exit 1 ;;
esac
