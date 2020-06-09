fmt:
  find . -name "*.js" -exec npx prettier --write {} +

serve:
  cd worker && wrangler preview

deploy:
  cd worker && wrangler publish
