default:
	cargo run

watch:
	cargo watch --clear --exec 'run -- --ucd-names ucd-names.txt'

search +REGEX='':
	cargo run -- --ucd-names ucd-names.txt '{{REGEX}}'

fetch:
	curl https://www.unicode.org/Public/UCD/latest/ucd/extracted/DerivedName.txt > names.txt
