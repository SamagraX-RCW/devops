[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/SamagraX-RCW/devops)

# devops
This repo holds the DevOps and Ansible jobs to deploy on the docker swarm along with a simpler docker-compose deployment. 

NOTE: Docker swarm deployment is a WIP 

DOCKER COMPOSE DEPLOYMENT  
-------------------------

- Install `make`
- Run `make` in the root directory of the project
- It will initialize the RCW services and Hashicorp Vault for you. 

**NOTE:** Restarting the RCW services would require to unseal the vault using the `unseal` tokens generated after
running `make`
