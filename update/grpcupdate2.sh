#!/bin/bash
cd

cd /usr/bin
wget -O fb-addgrpc "https://raw.githubusercontent.com/Phechr-2025/ssh-hop/main/grpc/sl-addgrpc.sh"
wget -O fb-delgrpc "https://raw.githubusercontent.com/Phechr-2025/ssh-hop/main/grpc/sl-delgrpc.sh"
wget -O fb-renewgrpc "https://raw.githubusercontent.com/Phechr-2025/ssh-hop/main/grpc/sl-renewgrpc.sh"
wget -O fb-cekgrpc "https://raw.githubusercontent.com/Phechr-2025/ssh-hop/main/grpc/sl-cekgrpc.sh"

chmod +x fb-addgrpc
chmod +x fb-delgrpc
chmod +x fb-renewgrpc
chmod +x fb-cekgrpc

cd
