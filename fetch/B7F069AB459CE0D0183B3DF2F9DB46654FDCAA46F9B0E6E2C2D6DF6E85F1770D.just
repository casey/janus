app_name = "nextaction"

build-crate:
  docker run --rm -v $PWD:/volume -w /volume -v $HOME/.cargo:/root/.cargo -t jimmycuadra/rust:1.16.0 cargo build --target x86_64-unknown-linux-gnu --release

build-image:
  docker build -t wooya/{{app_name}} .

build: build-crate build-image

push-image:
  docker push wooya/{{app_name}}

run:
  docker run --rm -it --env-file=.env wooya/{{app_name}}

pull:
  git pull