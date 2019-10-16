build:
  gatsby build

deploy:
  just build
  rsync -Prv -e "ssh -vv -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -F /dev/null" --delete ./public/* root@ameo.link:/var/www/jantix/
