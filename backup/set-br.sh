#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP=$(curl -s ipinfo.io/ip )
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -sS ifconfig.me )
echo "Checking VPS"
akbarvpn="raw.githubusercontent.com/Phechr-2025/ssh-hop/main/backup"

apt install rclone -y
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "https://${akbarvpn}/rclone.conf"
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
make install
cd
rm -rf wondershaper
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
SMTP_USER="${PHECHR_SMTP_USER:-${SMTP_USER:-}}"
SMTP_PASS="${PHECHR_SMTP_PASS:-${SMTP_PASS:-}}"
[ -z "$SMTP_USER" ] && read -rp "Backup SMTP email (blank to skip mail setup): " SMTP_USER
if [ -n "$SMTP_USER" ]; then
if [ -z "$SMTP_PASS" ]; then
read -rsp "Backup SMTP password/app password: " SMTP_PASS
echo
fi
cat > /etc/msmtprc <<EOF
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user ${SMTP_USER}
from ${SMTP_USER}
password ${SMTP_PASS}
logfile ~/.msmtp.log
EOF
chown -R www-data:www-data /etc/msmtprc
else
echo "Skipping backup mail setup; set PHECHR_SMTP_USER and PHECHR_SMTP_PASS to enable it."
fi
cd /usr/bin
wget -O autobackup "https://${akbarvpn}/autobackup.sh"
wget -O backup "https://${akbarvpn}/backup.sh"
wget -O restore "https://${akbarvpn}/restore.sh"
wget -O strt "https://${akbarvpn}/strt.sh"
wget -O limitspeed "https://${akbarvpn}/limitspeed.sh"
chmod +x autobackup
chmod +x backup
chmod +x restore
chmod +x strt
chmod +x limitspeed
cd
rm -f /root/set-br.sh
