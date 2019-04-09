build:
    cargo build

build-android:
    @docker-compose run android
    cp target/android-artifacts/app/build/outputs/apk/*.apk target/arm-linux-androideabi/debug/

build-release:
    cargo build --release

install-android:
    adb uninstall com.snsvrno.android_test
    adb install target/arm-linux-androideabi/debug/app-debug.apk