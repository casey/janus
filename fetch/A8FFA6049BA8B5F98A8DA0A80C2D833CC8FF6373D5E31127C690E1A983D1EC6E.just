default:
    echo "Please, choose an existing task."
    echo "If you are running this command for the first time, please consider running 'just setup'."

setup:
    cargo install ion-shell

# Docker jobs
docker-package-build:
    echo "Building a 'package-builder' docker image."
    sudo docker build --file "docker/package.Dockerfile" --tag nebula-package .
docker-package-run: docker-package-build
    echo "Running the 'package-builder'."
    rm ./work/package -rf
    mkdir ./work/package -p
    # Prepare the npk
    mkdir work/npk -p
    tar -zcvf work/npk/npk.tar.gz npk
    cp work/npk/npk.tar.gz alpine/packages/npk/npk.tar.gz -f
    sudo docker run -v "$(pwd)/alpine:/nebula" -v "$(pwd)/work/package:/nebula-work" nebula-package

docker-iso-build:
    echo "Building an 'ISO-builder' docker image."
    sudo docker build --file "docker/iso.Dockerfile" --tag nebula-iso .
docker-iso-run: docker-iso-build docker-package-run
    echo "Running the 'ISO-builder'."
    rm ./work/iso -rf
    mkdir ./work/iso -p
    sudo docker run -v "$(pwd)/alpine:/nebula" -v "$(pwd)/work/iso:/nebula-work" -v "$(pwd)/work/package:/nebula-package" nebula-iso

# Qemu testing
qemu: qemu-x86_64
qemu-x86_64:
    qemu-system-x86_64 -enable-kvm -boot d -cdrom work/iso/alpine-nebula.iso -m 2048