serve:
    watchexec -r -s SIGKILL 'cargo build && BERYL_DATABASE_URL=clickhouse://127.0.0.1:9000 BERYL_SCHEMA_FILEPATH=test/schema.json RUST_LOG=info ./target/debug/beryl'

serve-template:
    watchexec -r -s SIGKILL 'cargo build && BERYL_TEMPLATES_PATH=/home/hwchen/sos-beryl/sql-templates BERYL_DATABASE_URL=clickhouse://127.0.0.1:9000 BERYL_SCHEMA_FILEPATH=/home/hwchen/sos-beryl/schema.json RUST_LOG=info ./target/debug/beryl --addr localhost:3333'

create-test:
    clickhouse-client --query "`cat test-beryl.sql`"
    clickhouse-client --query "`cat test-beryl-insert.sql`"

drop-test:
    clickhouse-client --query 'drop table test_beryl'

# match will have better parsing so that `match` keyword is not needed in query
test:
    curl "127.0.0.1:9999/api/stores?number_employees=gt.500"
    curl "127.0.0.1:9999/api/stores?name=Store1"
    curl "127.0.0.1:9999/api/stores?stocks_product=NIKE,~FILO"
    curl "127.0.0.1:9999/api/stores?limit=1"
    curl "127.0.0.1:9999/api/stores?limit=2,1"
    curl "127.0.0.1:9999/api/stores?sort=number_employees.asc"
    curl "127.0.0.1:9999/api/stores/2"
