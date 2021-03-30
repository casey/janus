source_dir := "notes"
build_html_dir := source_dir + "/_build/html"

# -builder linkcheck does not work now
links:
   jupyter-book build {{source_dir}} --builder linkcheck

clean:
   rm -rf {{build_html_dir}}

build:
   jupyter-book build {{source_dir}}

show:
   start {{build_html_dir}}/index.html

pages:
   ghp-import -n -p -f {{build_html_dir}}

update:
   just build
   just show

publish:
   just clean
   just build
   just pages
