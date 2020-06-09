# Generoi openapi-kuvaukset
gen_openapi:
	@cd eperusteet-amosaa-service/ \
		&& mvn clean compile -P generate-openapi \
		&& cp target/openapi/amosaa.spec.json ../generated
