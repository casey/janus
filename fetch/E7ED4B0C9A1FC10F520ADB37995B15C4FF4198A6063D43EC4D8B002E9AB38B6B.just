codegen:
    `yarn bin`/apollo-codegen \
        introspect-schema \
        http://localhost:5000/graphql \
        --output pgql_schema.json
    `yarn bin`/apollo-codegen \
        generate \
        **/*.graphql \
        --schema pgql_schema.json \
        --target typescript \
        --output operation-result-types.ts

watch:
    watchexec \
    -r \
    -e rs,sql \
    -c cargo run

start-postgres:
    systemctl start postgresql

start-postgraphql:
    `yarn bin`/postgraphql \
        --default-role=loc_anonymous \
        --watch \
        --schema loc_api \
        --connection postgres://postgres@localhost:5432/pgql_experiment

