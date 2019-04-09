deploy:
	ansible-playbook --vault-password-file pass -e @secrets.yaml site.yaml -i hosts
	
retry:
	ansible-playbook --vault-password-file pass -e @secrets.yaml site.yaml -i hosts --limit @/$HOME/Workspace/brockonet.bugabinga.net/site.retry
