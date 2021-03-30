help:
  cargo run --package tgm --bin tgm -- --help

help_add:
  cargo run --package tgm --bin tgm -- help add

help_create:
  cargo run --package tgm --bin tgm -- help create

list:
  cargo run --package tgm --bin tgm -- list

add:
  cargo run --package tgm --bin tgm -- add --name=spring-boot-java --repo=https://github.com/linux-china/spring-boot-java-template --desc="Spring Boot App Java"

import:
  cargo run --package tgm --bin tgm -- import linux-china/spring-boot-java-template

remove:
  cargo run --package tgm --bin tgm -- remove spring-boot-java

create:
  cargo run --package tgm --bin tgm -- create spring-boot-java temp/demo

