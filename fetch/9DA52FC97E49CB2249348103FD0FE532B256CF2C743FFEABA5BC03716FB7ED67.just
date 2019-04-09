device = $(shell adb devices | grep '[0-9]' | head -1 | cut -d'	' -f1)
packageName = $(shell xmllint -xpath 'string(//manifest/@package)' AndroidManifest.xml)
mainActivityName = $(shell sed -e 's/android://g' AndroidManifest.xml | xmllint -xpath 'string(//activity[descendant::action[@name="android.intent.action.MAIN"]]/@name)' - )

appName = app
apkPath = $(appName).apk
adb = adb -s $(device)

default: build install start

fmt:
	java-fmt -r java/x/foretell/Main.java

install-gomobile:
	$$ANDROID_HOME/tools/bin/sdkmanager ndk-bundle && \
	go get golang.org/x/mobile/cmd/gomobile && \
	gomobile init -ndk $$ANDROID_HOME/ndk-bundle

bind:
	gomobile bind -target=android github.com/aoeu/foretell/noaa && mv noaa.aar lib/

build:
	./build.sh
	
install:
	$(adb) install -r $(apkPath)

start:
	$(adb) shell am start -n $(packageName)/$(packageName)$(mainActivityName)
