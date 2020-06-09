_default:
    @just --list

# Convert SASS style sheet to CSS
sass:
    @sassc --style compact static/css/style.scss static/css/style.css
    @echo '==> SASS build done'

# Serve the site directly on http://localhost:1313/
serve: sass
    @hugo server

# Clean output folder
clean:
    @rm -rf out/
    @echo '==> Output folder removed'

# Generate the site
build:
    @hugo
    @echo '==> Hugo build done'

# Optimize site with AssetGraph
optimize:
    @docker run \
        --interactive \
        --tty \
        --rm \
        --volume="$(pwd)"/out:/site \
        assetgraph/assetgraph-builder \
        --root /site/unoptimized \
        --outroot /site/optimized \
        --stoponwarning \
        --subresourceintegrity \
        --optimizeimages \
        /site/unoptimized/images/logo.png \
        /site/unoptimized/index.html \
        /site/unoptimized/index.xml \
        /site/unoptimized/404.html \
        /site/unoptimized/keybase.txt \
        /site/unoptimized/robots.txt \
        /site/unoptimized/sitemap.xml
    @echo '==> AssetGraph build done'

# Build the final, optimized site
dist: sass clean build optimize

# Deploy the site to Google Cloud Storage
deploy:
    @gsutil -m rsync -rJ out/optimized/ gs://tenzer.dk/
    @echo "Purging Cloudflare's cache"
    @flarectl zone purge --zone tenzer.dk --everything
