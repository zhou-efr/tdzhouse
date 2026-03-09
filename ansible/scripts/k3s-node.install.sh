sh -c "$(wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/scripts/debian/proxy-setup.install.sh -O -)"
sh -c "$(wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/scripts/debian/quick-debian.install.sh -O -)"

curl -sfL https://get.k3s.io | sh -s - server --cluster-init --tls-san=10.1.1.49