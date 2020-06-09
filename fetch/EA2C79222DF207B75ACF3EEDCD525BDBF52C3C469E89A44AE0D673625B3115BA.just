local:
	zola serve

blog:
	zola build
	rsync -avx --exclude .DS_Store public hetzner:/web/net/atta-metta/www/htdocs/
