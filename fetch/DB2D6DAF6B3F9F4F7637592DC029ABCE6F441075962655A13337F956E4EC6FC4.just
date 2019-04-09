# development server
debug:
  hugo -D server 

# Náhled na stránky bez debug
site:
  hugo server

# development server with full rebuild
full:
  hugo -D --disableFastRender server 

# automatický commit a push zdrojáků na server
push:
  git-autocommit
  git push
  fping ws && ssh ws "cd Projects/blog/ && /home/martin/bin/git-update"

# publish: push
