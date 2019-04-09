version = "0.2.0"
viewer = "sabaki"

# Print the URL for a random kifu
print:
	python3 ./random-gokifu-sgf

# Download a random kifu to the temporary directory
download:
	SGF_FILE=$(mktemp --tmpdir=/tmp --suffix=".sgf")
	curl $(python3 ./random-gokifu-sgf) -o $SGF_FILE
	echo "\nDownloaded kifu as $SGF_FILE"

# View an SGF file
view FILE:
	{{viewer}} {{FILE}}
