# Permanent proxy setup for later
echo "http_proxy=http://proxy.out.tdz.ovh:8080/" | sudo tee -a /etc/environment
echo "https_proxy=http://proxy.out.tdz.ovh:8080/" | sudo tee -a /etc/environment
echo "ftp_proxy=http://proxy.out.tdz.ovh:8080/" | sudo tee -a /etc/environment
echo "no_proxy=localhost,127.0.0.1,localaddress,.localdomain.com" | sudo tee -a /etc/environment

# Apt proxy setup
echo 'Acquire::http::Proxy "http://proxy.out.tdz.ovh:8080/";' | sudo tee /etc/apt/apt.conf.d/95proxies
echo 'Acquire::https::Proxy "http://proxy.out.tdz.ovh:8080/";' | sudo tee -a /etc/apt/apt.conf.d/95proxies

# Temporary proxy setup for the script usage
export http_proxy="http://proxy.out.tdz.ovh:8080/"
export https_proxy="http://proxy.out.tdz.ovh:8080/"
export ftp_proxy="http://proxy.out.tdz.ovh:8080/"
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"