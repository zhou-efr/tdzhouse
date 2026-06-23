# TDZhouse
Collection de scripts Terraform et Ansible pour créer des machines de base sur proxmox.
# Quick Debian
## Workflow
Le script d'installation est une base de bash qui va appeler à la suite des playbook Ansible et Terraform.
## 1. Bash
Le script bash comment car chiffrer le vault ansible pour l'utilisation par les playbooks et par Terraform. Celui-ci est
est ensuite déchiffré pour permettre de l'éditer. `configuration.yml` n'est pas supposé être plublié sur un git, il y a 
le fichier `configuration.template.yml` pour ça.
## 2. Ansible pre-configuration
Pour créer une VM Debian et la personnaliser avec _cloud init_ on doit partir d'un template à cloner. Pour cela on
on utilise un script ansible qui va suivre la procédure suivante :
1. Vérification existence clone d'une template de clone cloud-init en `vmid` 8000, nommée `template-debian`, si oui, arrêt du script
2. Upload de l'image cloud-init
3. Création d'une VM avec l'image
4. Conversion de la VM en Template de clonage
## 3. Proxmox provider
Pour utiliser proxmox on doit renseigner les secrets à l'échelle de la variable d'environnement car le bloc `provider`
n'est pas capable de lire les variables `local`. Pour cela on ajoute les lignes suivante dans le script bash :
```bash
YAML=$(ansible-vault decrypt ./vars/configuration.yml \
  --vault-password-file ./vars/secret.pass \
  --output -)

export PROXMOX_VE_ENDPOINT="https://$(echo "$YAML" | yq .proxmox_host):8006/"
export PROXMOX_VE_API_TOKEN="$(echo "$YAML" | yq .proxmox_user)!$(echo "$YAML" | yq .proxmox_token_id)=$(echo "$YAML" | yq .proxmox_token_secret)"
export PROXMOX_VE_INSECURE=true
```
## 4. Terraform
### Secrets
Terraform commence par extraire la configuration souhaité pour debian depuis le vault ansible :
```tf
resource "ansible_vault" "secrets" {
  vault_file          = "./vars/configuration.yml"
  vault_password_file = "./vars/secret.pass"
}

locals {
  decoded_vault_yaml = yamldecode(ansible_vault.secrets.yaml)
}
```
### Instance
On utilise ensuite ces valeurs dans une ressource `proxmox_virtual_environment_vm`
# Développement
## Gestion des variables
Certaines variables peuvent être sensibles (p. ex. mots de passe, ip, etc.) De plus, les variables sont partagés entre 
Terraform et Ansible. Enfin, certaines variables sont complexes (p. ex. disques, réseaux, etc.) Ainsi, pour conserver 
toutes les variables au même endroits (`configuration.yml`) j'ai choisi d'utiliser `ansible-vault`. Cette solution est 
native à Ansible, et il existe un _provider_ Terraform compatible 
([voir lien](https://registry.terraform.io/providers/ansible/ansible/latest/docs)).
1. Mettre les variables utilisés dans un fichier `./vars/configuration.yml`
2. Chiffrer le fichier avec 
```bash
ansible-vault encrypt ./vars/configuration.yml --vault-password-file ./vars/secret.pass
```
> **Note**: Pour déchiffrer le fichier : 
> ```bash
> ansible-vault decrypt ./vars/configuration.yml --vault-password-file ./vars/secret.pass
> ```

