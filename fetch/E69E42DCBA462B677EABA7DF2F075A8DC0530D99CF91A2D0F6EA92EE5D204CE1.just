device = $(shell adb devices | grep '[0-9]' | head -1 | cut -d'	' -f1)
packageName = $(shell find . -name AndroidManifest.xml | xargs xmllint -xpath 'string(//manifest/@package)')
mainActivityName = $(shell find . -name AndroidManifest.xml | xargs sed -e 's/android://g' | xmllint -xpath 'string(//activity[descendant::action[@name="android.intent.action.MAIN"]]/@name)' - )

appID = $(shell grep applicationId */build.gradle | head -1 | sed 's/.*"\(.*\)".*/\1/')
appName = app
apkPath = $(appName).apk
adb = adb -s $(device)

default: build install start

build:
	./build.sh 2>/dev/null

assemble:
	(./gradlew assembleDebug 2>&1 | grep -v '^:.*:.*' | grep -v 'incubating') 1>&2

compile:
	(./gradlew compileDebugJavaWithJavac 2>&1 | grep -v '^:.*:.*' | grep -v 'incubating') 1>&2

install:
	$(adb) install -r $(apkPath)

uninstall:
	$(adb) uninstall $(packageName)

start:
	$(adb) shell am start -n $(packageName)/$(packageName)$(mainActivityName)

clean:
	rm $(apkPath)
