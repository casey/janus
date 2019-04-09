all:
    atspkg clean ; atspkg nuke ; atspkg build --target=arm-linux-gnueabihf
    atspkg clean ; atspkg nuke ; atspkg build --target=x86_64-unknown-redox
    atspkg clean ; atspkg nuke ; atspkg build --target=aarch64-linux-gnu
    atspkg clean ; atspkg nuke ; atspkg build --target=s390x-linux-gnu
    atspkg clean ; atspkg nuke ; atspkg build --target=arm-linux-gnueabi
    atspkg clean ; atspkg nuke ; atspkg build --target=sparc64-linux-gnu
