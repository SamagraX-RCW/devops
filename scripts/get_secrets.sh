!#/bin/bash
export VAULT_ADDR=http://127.0.0.1:8200

init_output=$(vault operator init)

# Extract the initial root token
root_token=$(echo "$init_output" | grep "Initial Root Token:" | awk '{print $NF}')

# Set the root token as an environment variable
export VAULT_TOKEN="$root_token"

# Enable KV secrets engine
vault secrets enable -path=kv-secret kv

# Insert secrets
vault kv put registry-secrets/auth username=admin password=admin

# Retrieve secrets from Vault
username=$(vault kv get -field=username registry-secrets/auth)
password=$(vault kv get -field=password registry-secrets/auth)

# Set environment variables inside the Jenkins container
docker exec -it devops-jenkins-1 /bin/sh -c "export VAULT_USERNAME=$username && export VAULT_PASSWORD=$password"
