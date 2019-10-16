parcelArgs = "--out-dir build/"

# Build the entire project
build: clean build-background build-content-script build-options copy-manifest

build-background:
  npx parcel build {{parcelArgs}} src/background.js

build-content-script:
  npx parcel build {{parcelArgs}} src/content_script.js

build-options:
  npx parcel build {{parcelArgs}} --public-url "./" src/options/options.html

copy-manifest:
  cp src/manifest.json build/manifest.json

clean:
  rm -rf build/

