default: build

build:
	/Users/travis/code/aoeu/derp/gradlew --info assembleRelease
sign:
	cp  build/outputs/apk/derp-release-unsigned.apk  build/outputs/apk/derp-release-signed.apk
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore derp-release-key.keystore build/outputs/apk/derp-release-unsigned.apk derp_key
	rm build/outputs/apk/derp-release.apk
	zipalign -v 4 build/outputs/apk/derp-release-unaligned.apk build/outputs/apk/derp-release.apk
install:
	adb uninstall  less.apps.derp
	adb install -r build/outputs/apk/derp-release.apk
