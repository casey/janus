deploy:
	ansible-playbook site.yml -i hosts -l webservers -t letsencrypt
	ansible-playbook site.yml -i hosts -l webservers -t letsencrypt -e '{"letsencrypt_cert":{"name":"brocko","domains":["brockonet.bugabinga.net"],"challenge":"http","http_auth":"standalone"}}'
	ansible-playbook site.yml -i hosts
