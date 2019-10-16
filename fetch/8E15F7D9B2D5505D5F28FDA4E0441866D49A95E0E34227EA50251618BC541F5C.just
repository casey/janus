all:
    ansible-playbook -i hosts --ask-become-pass install.yml

link:
    ansible-playbook -i hosts install.yml --tags "link"

julia:
    ansible-playbook -i hosts install.yml --tags "julia"

vim:
    ansible-playbook -i hosts install.yml --tags "vim" --ask-become-pass install.yml
