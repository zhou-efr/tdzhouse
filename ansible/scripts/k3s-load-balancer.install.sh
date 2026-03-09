sh -c "$(wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/scripts/debian/proxy-setup.install.sh -O -)"
sh -c "$(wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/scripts/debian/quick-debian.install.sh -O -)"

apt install nginx -y
rm /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/config/nginx/nginx.conf -P /etc/nginx/
systemctl restart nginx
