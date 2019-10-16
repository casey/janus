publish_doc:
	@rm -rf target/doc
	@rm -f doc.zip
	@cargo test
	@cargo doc --no-deps
	@cd target/doc; zip -r ../../doc.zip *
	@curl -H "Content-Type: application/zip" -H "Authorization: Bearer $TOKEN" --data-binary "@doc.zip" https://api.netlify.com/api/v1/sites/$SITE_NAME.netlify.com/deploys
	@rm -f doc.zip

doc:
	@cargo doc --no-deps

open_doc:
	@cargo doc --no-deps --open
