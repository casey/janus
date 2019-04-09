@prepare:
    sed -i $'s/\r$//' ./share/functions.sh
    sed -i $'s/\r$//' ./share/setup.sh

@validate VERSION:
    packer validate packer.{{ VERSION }}.json

build VERSION: prepare
    packer build packer.{{ VERSION }}.json

deploy: prepare
    packer build packer.deploy.json