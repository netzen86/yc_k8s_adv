#!/bin/bash

set -eu -o pipefail

###
# Requirements
###
sudo apt install pwgen

###
# Variables
###
export PASSWORD=$(pwgen -1 20)
export PUBLIC_IP=$(curl --silent http://ifconfig.me)
export VSCODE_PORT=8088
# Change this
export EMAIL="netzen@yandex.ru>"
export FQDN="vsc-srv.netzen.dev"

###
# code-server
###
# Install
curl -fsSL https://code-server.dev/install.sh | sh
echo "*** vscode server installed ***"
sudo systemctl enable --now code-server@$USER
echo "*** code-server service enabled ***"

# Configure
cat <<EOF > ~/.config/code-server/config.yaml
bind-addr: 127.0.0.1:${VSCODE_PORT}
auth: password
password: ${PASSWORD}
cert: false
EOF

# Restart
sudo systemctl restart code-server@$USER
sleep 10

###
# Let's Encrypt (optional)
###
# Install
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx

# Configure Nginx
cat <<EOF | sudo tee /etc/nginx/sites-available/code-server
server {
    listen 80;
    listen [::]:80;
    server_name ${FQDN};

    location / {
      proxy_pass http://localhost:${VSCODE_PORT}/;
      proxy_set_header Host \$host;
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
EOF

if [ ! -f /etc/nginx/sites-enabled/code-server ]; then
  sudo ln -s ../sites-available/code-server /etc/nginx/sites-enabled/code-server
fi

# Enable Let's Encrypt
sudo certbot --non-interactive --redirect --agree-tos --nginx -d ${FQDN} -m ${EMAIL}

# Echo URL
echo URL https://${FQDN}
cat ~/.config/code-server/config.yaml | grep "password:"