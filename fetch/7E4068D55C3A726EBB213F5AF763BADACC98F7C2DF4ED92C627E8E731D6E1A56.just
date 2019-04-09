dummy:

setup:
	vagrant up

ping:
	ansible -i hosts.ini vagrant -m ping -u vagrant --private-key=.vagrant/machines/default/virtualbox/private_key

play-book:
	ansible-playbook -i hosts.ini --private-key=.vagrant/machines/default/virtualbox/private_key book.yml

# vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
