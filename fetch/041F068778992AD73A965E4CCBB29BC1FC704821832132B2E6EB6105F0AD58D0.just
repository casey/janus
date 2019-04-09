# display available recipes
all:
    @just --list

# installation
install:
    yarn

# running / development
serve:
    ember serve

# build production release
release:
    ember build --environment production

# deploy glimmer app
deploy:
    ember deploy production

# lint typescript
lint:
    @tslint -c tslint.json 'src/**/*.ts' || true

# count non-empty lines of code
sloc:
    @find ./src -type f -name "*.ts" -o -name "*.hbs" -o -name "*.scss" -o -name "*.html" | xargs cat | sed '/^\s*$/d' | wc -l

# cleans the project
@clean:
    yarn clean
    rm .yarnclean
    rm -fr node_modules
    rm -fr dist
    rm -fr tmp
