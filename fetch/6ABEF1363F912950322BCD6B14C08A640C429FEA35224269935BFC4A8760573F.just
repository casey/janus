repo_url = "https://github.com/vitiral/artifact-example"

build_site_args = '--path-url "' + repo_url + '/blob/$(git rev-parse --verify HEAD)/{path}#L{line}"'

site:
	art export html {{build_site_args}}
