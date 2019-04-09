render:
	asciidoctor README.adoc -o docs/index.html
	
watch:
	@watchexec -i 'docs/*' 'date "+%+: rendering..." && just --quiet render'

open:
	open docs/index.html
