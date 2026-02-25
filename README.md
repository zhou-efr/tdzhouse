# TDZ House
# <span style="color:rgb(0, 112, 192)">Configuration</span>
## <span style="color:rgb(255, 192, 0)">Git</span>
Les variables d'environnement se trouvent dans un fichier .env à la racine du projet. Il faut utiliser les 
fonctionnalités de PyCharm pour lancer Terraform avec les bonnes variables d'environnement.
## <span style="color:rgb(255, 192, 0)">Inventaire</span>
### <span style="color:rgb(115, 115, 115)">DMZ</span>
- Pare-feu de bordure - **PFSense** - `dmz-fw`
- Reverse proxy web - **Nginx** - `dmz-rp`
- Proxy web - **Tiny proxy** - `dmz-proxy`
- Terminaison VPN - **Wireguard** - `dmz-vpn`
### <span style="color:rgb(115, 115, 115)">Intranet</span>
- Pare-feu interne - **Fortigate** - `lan-fg`
- **Home assistant** - `lan-ha`
- Administration conteneurs - **Portainer** - `lan-k3s-x`
- Ingress controller - **Traefik** - `lan-k3s-x`
- Web recettes - **NodeJS** - `lan-k3s-x`
- **Actual budget** - `lan-k3s-x`
- **ESPHome** - `lan-k3s-x`
- PDF tools - **Stirling PDF** - `lan-k3s-x`
## <span style="color:rgb(255, 192, 0)">Matrice de flux</span>

| src\dst         | 0                               | 1                               | 2         | 3                    | 4           | 5                     | 6         | 7                    |
|-----------------| ------------------------------- | ------------------------------- | --------- | -------------------- | ----------- | --------------------- | --------- | -------------------- |
| 0 - `bbox`      |                                 | 51820 (UDP) - 443 (TCP)         |           |                      |             |                       |           |                      |
| 1 - `dmz-fw`    | 53 (UDP) - 80 (TCP) - 443 (TCP) |                                 | 443 (TCP) |                      | 51820 (UDP) |                       |           |                      |
| 2 - `dmz-rp`    | 80 (TCP) - 443 (TCP)            | 53 (UDP) - 443 (TCP)            |           | 80 (TCP) - 443 (TCP) |             | Forwarded Ports (TCP) |           |                      |
| 3 - `dmz-proxy` |                                 | 53 (UDP) - 80 (TCP) - 443 (TCP) |           |                      |             |                       |           |                      |
| 4 - `dmz-vpn`   |                                 | 53 (UDP)                        |           | 80 (TCP) - 443 (TCP) |             |                       |           |                      |
| 5 - `lan-fg`    |                                 | 53 (UDP)                        |           | 80 (TCP) - 443 (TCP) |             |                       | 443 (TCP) | 80 (TCP) - 443 (TCP) |
| 6 - `lan-ha`    |                                 |                                 |           | 80 (TCP) - 443 (TCP) |             | 53 (UDP)              |           |                      |
| 7 - `lan-k3s-x` |                                 |                                 |           | 80 (TCP) - 443 (TCP) |             | 53 (UDP)              |           |                      |
| 8 - `xiaomi`    |                                 | 22 (TCP)                        | 22 (TCP)  | 22 (TCP)             | 22 (TCP)    | 22 (TCP)              | 22 (TCP)  | 22 (TCP)             |
## <span style="color:rgb(255, 192, 0)">Réseaux</span>

### <span style="color:rgb(115, 115, 115)">DMZ</span>
- DMZ web - 10.0.1.0 / 24
	- `dmz-fw` - static 10.0.1.1
	- `dmz-rp` - static 10.0.1.50 
	- `lan-fg` - static 10.0.1.49
- DMZ out - 10.0.2.0 / 24
	- `dmz-fw` - static 10.0.2.1
	- `dmz-proxy` - static 10.0.2.50
	- `lan-fg` - static 10.0.2.49
- DMZ out - 10.0.3.0 / 24
	- `dmz-fw` - static 10.0.3.1
	- `dmz-vpn` - static 10.0.3.50
### <span style="color:rgb(115, 115, 115)">Intranet</span>
- LAN web - 10.1.1.0 / 24
	- `lan-fg` - static 10.1.1.1
	- `lan-k3s-0` - static 10.1.1.50
	- `lan-k3s-1` - static 10.1.1.51
	- `lan-k3s-2` - static 10.1.1.52
- LAN ha - 10.1.2.0 / 24
	- `lan-fg` - static 10.1.2.1
	- `lan-ha` - static 10.1.2.50
### <span style="color:rgb(115, 115, 115)">VPN</span>
- VPN satisfactory - 10.2.1.0/24
	- `dmz-vpn` - static 10.2.1.1
	- `PC-MP` - static 10.2.1.50
# <span style="color:rgb(0, 112, 192)">Scripts</span>
## <span style="color:rgb(255, 192, 0)">VPN</span>
- Le script vérifie toutes les minutes les lasts handshake de chaque peer. Si le dernier handshake date d'il y a 
plus de 180s il est considéré comme déconnecté. À la connexion ou la déconnexion, le script envoi un signal au home
assistant.
- Pour executer le script toutes les minutes on enregistre le bash dans un crontab. 
