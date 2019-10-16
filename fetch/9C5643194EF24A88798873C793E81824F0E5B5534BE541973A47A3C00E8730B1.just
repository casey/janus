update:
	wget -O routes/latest.json $(curl https://api.github.com/repos/octokit/routes/releases | jq -r \
			'.[0].assets | map(select(.name == "api.github.com.json")) | .[0].browser_download_url')
