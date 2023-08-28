#!/bin/bash

root_token=$(sed -n 's/Initial Root Token: \(.*\)/\1/p' keys.txt | tr -dc '[:print:]')

VAULT_TOKEN=$root_token

# Retrieve secrets from Vault
username=$(vault kv get -field=username kv/registry-secrets)
password=$(vault kv get -field=password kv/registry-secrets)

# Set .env file inside the Jenkins container
docker exec -it jenkins /bin/sh -c "cd /var/jenkins_home && echo REGISTRY_USERNAME=$username > .env && echo REGISTRY_PASSWORD=$password >> .env"

docker exec -it nginx /bin/sh -c "cd /etc/nginx/conf.d && echo "$username:$password" > nginx.htpasswd"
