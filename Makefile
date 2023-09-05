.PHONY: start

start:
	bash setup_vault_gha.sh rcw-compose.yml vault
	docker-compose -f rcw-compose.yml up -d
