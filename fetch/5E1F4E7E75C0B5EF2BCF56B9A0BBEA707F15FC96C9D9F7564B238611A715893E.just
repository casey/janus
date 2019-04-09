dbschema = "mysql"
dbhost = "localhost"
dbuser = "root"
dbpassword = "password"
dbname = "guapian"


help:
  @just -l

installcli:
  cargo install diesel_cli --features mysql

setupdb:
  DATABASE_URL="{{dbschema}}://{{dbuser}}:{{dbpassword}}@{{dbhost}}/{{dbname}}" diesel setup

migrationdb:
  DATABASE_URL="{{dbschema}}://{{dbuser}}:{{dbpassword}}@{{dbhost}}/{{dbname}}" diesel migration run

gen_schema:
  DATABASE_URL="{{dbschema}}://{{dbuser}}:{{dbpassword}}@{{dbhost}}/{{dbname}}" diesel print-schema > src/schema.rs

run:
  DATABASE_URL="{{dbschema}}://{{dbuser}}:{{dbpassword}}@{{dbhost}}/{{dbname}}" cargo run
