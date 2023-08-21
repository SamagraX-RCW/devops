.PHONY: compose-init

compose-init:
	wget --no-clobber https://github.com/SamagraX-RCW/identity/raw/main/vault/vault.json
	wget --no-clobber https://github.com/SamagraX-RCW/identity/raw/main/build/setup_vault_gha.sh
	cp .env.sample .env
	bash setup_vault_gha.sh rcw-compose.yml vault
	docker-compose -f rcw-compose.yml up -d identity
	docker-compose -f rcw-compose.yml up -d schema
	docker-compose -f rcw-compose.yml up -d credential
