

apt install build-essential
git clone https://github.com/tinyproxy/tinyproxy.git /opt/tinyproxy
cd /opt/tinyproxy || exit
configure --enable-filter
make
make install
mkdir /etc/tinyproxy
tee /etc/tinyproxy/tinyproxy.conf << EOF
Port 8080
Listen 10.0.2.50
Allow 10.0.0.0/8
Timeout 600
LogLevel Info
Logfile "/var/log/tinyproxy/default.conf.log"
EOF
chmod 766 /etc/tinyproxy/tinyproxy.conf
mkdir /var/log/tinyproxy
touch /var/log/tinyproxy/default.conf.log
chmod 766 /var/log/tinyproxy/default.conf.log
tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf