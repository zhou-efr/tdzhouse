sh -c "$(wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/scripts/debian/proxy-setup.install.sh -O -)"
sh -c "$(wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/scripts/debian/quick-debian.install.sh -O -)"
sh -c "$(wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/scripts/debian/docker.install.sh -O -)"

# https://networkpulse.fr/configurer-traefik-avec-le-challenge-http-ovh-pour-securiser-votre-homelab/
mkdir /opt/containers
mkdir /opt/containers/traefik
docker network create web
mkdir /opt/containers/traefik/letsencrypt
touch /opt/containers/traefik/letsencrypt/acme.json
wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/config/traefik/compose.yml -O /opt/containers/traefik/compose.yml
wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/config/traefik/dynamic.yml -O /opt/containers/traefik/dynamic.yml
wget https://raw.githubusercontent.com/zhou-efr/tdzhouse/master/ansible/config/traefik/traefik.yml -O /opt/containers/traefik/traefik.yml
docker compose /opt/containers/traefik/compose.yml
