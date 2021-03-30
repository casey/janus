# nix

build package +ARGS="":
  nix-build nix/default.nix -I project_dir=$PWD --argstr github_client_id $GITHUB_CLIENT_ID --argstr github_client_secret $GITHUB_CLIENT_SECRET --no-out-link --show-trace -A {{package}} {{ARGS}}

store-path package:
  nix-store -q --outputs $(nix-instantiate ./nix/default.nix -I project_dir=$PWD --argstr github_client_id $GITHUB_CLIENT_ID --argstr github_client_secret $GITHUB_CLIENT_SECRET -A {{package}}) | cat

# deploy

deploy ip:
  #!/usr/bin/env bash
  source .env
  just build-front
  just build oikos_service
  nix-copy-closure --to root@{{ip}} `just store-path oikos_service`
  ssh root@{{ip}} nix-env -i `just store-path oikos_service`
  ssh root@{{ip}} cp /root/.nix-profile/lib/systemd/system/oikos.service /etc/systemd/system/
  ssh root@{{ip}} systemctl daemon-reload
  ssh root@{{ip}} systemctl restart oikos

# Openapi

generator +OPTIONS="":
  docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v ${PWD}:/local -w /local openapitools/openapi-generator-cli:v4.3.0 generate \
    --enable-post-process-file \
    --generate-alias-as-model \
    {{OPTIONS}}

openapi:
  #!/usr/bin/env bash
  set -e
  if [ -f .env ]; then source .env; fi
  # api
  just generator -g openapi --package-name oikos_api -i /local/src/rust/oikos_server/reference/openapi.yaml -o ./src/web/public
  openapi_generator src/openapi_templates/rust ./src/web/public/openapi.json -d ./src/rust/oikos_api
  cargo fmt

build-front:
  #!/usr/bin/env bash
  cd src/rust/oikos_web
  wasm-pack build --target web --out-name wasm --out-dir ../oikos_server/static
