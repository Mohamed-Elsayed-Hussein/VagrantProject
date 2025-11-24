#!/bin/bash
set -e

# WEB01 Provisioning Script

echo "Setting up hosts file..."
cat <<EOF | sudo tee -a /etc/hosts
192.168.56.11 web01
192.168.56.12 app01
192.168.56.13 rmq01
192.168.56.14 mc01
192.168.56.15 db01
EOF

echo "Installing Nginx..."
sudo yum install nginx -y

echo "Configuring Nginx..."
sudo sed -i 's/server_name[[:space:]]\+_;/server_name server1;/' /etc/nginx/nginx.conf

sudo tee /etc/nginx/conf.d/server.conf  << EOF
upstream vproapp {
server app01:8080;
}
server {
 listen 80;
 location / {
  proxy_pass http://vproapp;
 }
}
EOF

sudo systemctl restart nginx
sudo systemctl enable nginx

echo "WEB01 setup complete."
