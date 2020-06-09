build-all:
  #!/bin/bash
  # Check if our dependency license list needs to be refreshed
  package_hash=$(md5sum ./package.json)
  #if [[ $package_hash != $(cat ./package_hash) ]]; then
  #       echo $package_hash >./package_hash
  #       echo "Generating new liceneses listing..."
  #       yarn gen-licenses
  #fi

  rm -rf .cache public
  cd triangles && \
    ./release.sh && \
    wasm-bindgen ./target/wasm32-unknown-unknown/release/*.wasm --browser --remove-producers-section --out-dir ./build
  cd ..
  cp ./triangles/build/* ./src
  just opt
  yarn build

opt:
  wasm-opt ./src/*.wasm --strip-debug -O4 -c -o ./src/*.wasm

run:
  cd triangles && \
    ./build.sh && \
    wasm-bindgen ./target/wasm32-unknown-unknown/debug/*.wasm --browser --remove-producers-section --out-dir ./build
  cd ..
  cp ./triangles/build/* ./src/
  gatsby develop

deploy:
  rsync -Prv -e "ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -F /dev/null" --delete ./public/* root@ameo.link:/var/www/cprimozic/
