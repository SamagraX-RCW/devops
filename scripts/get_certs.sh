#!/bin/bash

# This script does the following things
# * Stores the private key and certificate file to vault
# * Remove the SSL certificated from the location

# Paths for the SSL certificate files
PRIVATE_KEY_PATH="../nginx_config/ssl/private_key.pem"
CERTIFICATE_PATH="../nginx_config/ssl/certificate.crt"

# Read the private key and certificate content
PRIVATE_KEY_CONTENT=$(cat "$PRIVATE_KEY_PATH")
CERTIFICATE_CONTENT=$(cat "$CERTIFICATE_PATH")

# Store the SSL certificate files in HashiCorp Vault using the KV secrets engine
vault kv put secret/ssl_certificate private_key="$PRIVATE_KEY_CONTENT" certificate="$CERTIFICATE_CONTENT"

# Delete the SSL certificate files
rm -rf "$PRIVATE_KEY_PATH" "$CERTIFICATE_PATH"

echo "SSL certificate files stored in Vault using KV secrets engine and deleted from the local location."