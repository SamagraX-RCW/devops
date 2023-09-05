#!/bin/bash

# This script does the following things
# * Retrieves the root token from keys.txt
# * Pulls registry username and password from vault
# * Rename .env.example to .env
# * Stores the username and password file as env inside the nginx container

root_token=$(sed -n 's/Initial Root Token: \(.*\)/\1/p' keys.txt | tr -dc '[:print:]')

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=$root_token

# Retrieve secrets from Vault
username=$(vault kv get -field=username kv/registry-secrets)
password=$(vault kv get -field=password kv/registry-secrets)

# Set .env file inside the Jenkins container
cp -n ~/devops/.env.sample ~/devops/.env
echo "REGISTRY_USERNAME=${username}" >> .env && echo "REGISTRY_PASSWORD=${password}" >> .env

docker exec -it nginx /bin/sh -c "cd /etc/nginx/conf.d && echo ${username}:${password} > nginx.htpasswd"

docker restart nginx