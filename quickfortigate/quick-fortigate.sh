# ─────────────────────────────────────────────
# Setup secrets and configuration
# ─────────────────────────────────────────────
ansible-vault encrypt --vault-password-file ./src/vars/secret.pass ./src/vars/configuration.yml

# ─────────────────────────────────────────────
# Initialise proxmox
# ─────────────────────────────────────────────
ansible-playbook --vault-password-file ./src/vars/secret.pass -i ./src/vars/inventory.yml ./src/setup_fortigate.yml

# ─────────────────────────────────────────────
# Post installation setup
# ─────────────────────────────────────────────
ansible-playbook --vault-password-file ./src/vars/secret.pass -i ./src/vars/temp_inventory.yml ./src/post_install.yml

# ─────────────────────────────────────────────
# Cleaning
# ─────────────────────────────────────────────
ansible-vault decrypt --vault-password-file ./src/vars/secret.pass ./src/vars/configuration.yml
