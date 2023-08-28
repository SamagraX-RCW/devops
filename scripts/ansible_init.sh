sudo apt-add-repository ppa:ansible/ansible

sudo apt update
sudo apt install ansible

ansible-playbook -i ./ansible_workspace_dir/inventory/hosts ansible-playbook.yml