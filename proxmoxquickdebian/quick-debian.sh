# ─────────────────────────────────────────────
# Setup secrets and configuration
# ─────────────────────────────────────────────
ansible-vault encrypt --vault-password-file ./vars/secret.pass ./vars/configuration.yml

# ─────────────────────────────────────────────
# Initialise proxmox
# ─────────────────────────────────────────────
ansible-playbook --vault-password-file ./vars/secret.pass -i ./vars/inventory.yml ./upload_cloud_init.yml
YAML=$(ansible-vault decrypt ./vars/configuration.yml \
  --vault-password-file ./vars/secret.pass \
  --output -)

export PROXMOX_VE_ENDPOINT="https://$(echo "$YAML" | yq .proxmox_host):8006/"
export PROXMOX_VE_API_TOKEN="$(echo "$YAML" | yq .proxmox_user)!$(echo "$YAML" | yq .proxmox_token_id)=$(echo "$YAML" | yq .proxmox_token_secret)"
export PROXMOX_VE_INSECURE=true

terraform init
terraform plan
terraform apply
#TF_LOG=DEBUG terraform apply

# ─────────────────────────────────────────────
# Post installation setup
# ─────────────────────────────────────────────



# ─────────────────────────────────────────────
# Cleaning
# ─────────────────────────────────────────────
ansible-vault decrypt --vault-password-file ./vars/secret.pass ./vars/configuration.yml
