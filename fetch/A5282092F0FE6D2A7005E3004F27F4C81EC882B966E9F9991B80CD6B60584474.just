docs-watch:
    watchexec --exts lua -- docco -l classic *.lua \&\& mv docs/\{callbag-basics,index\}.html

docs:
    docco -l classic *.lua && mv docs/{callbag-basics,index}.html
