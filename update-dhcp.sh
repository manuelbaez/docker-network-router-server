ansible-playbook ./ansible/playbooks/setup-dhcp-server.yaml -i ./ansible/inventory.yaml  --extra-vars "varsFile=home-env-vars.yaml"