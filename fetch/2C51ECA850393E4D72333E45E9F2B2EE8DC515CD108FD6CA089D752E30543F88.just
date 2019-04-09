base-url-bittrex = 'https://bittrex.com/api/v1.1/public/getorderbook?type=both&market='
dest-dir = 'data'
precomp = 'lib/.precomp'

clean-data:
	rm -f data/*.json

clean-precomp:
	rm -rf {{precomp}}

clean: clean-data clean-precomp

fetch market: clean-data
	@echo 'Fetching market: {{market}}...'
	curl '{{base-url-bittrex}}{{market}}' | jq -M '.' > '{{dest-dir}}/{{market}}.json'

# vim: set filetype=make foldmethod=marker foldlevel=0:
