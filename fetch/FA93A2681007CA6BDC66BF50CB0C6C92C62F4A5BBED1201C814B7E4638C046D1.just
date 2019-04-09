help:
	@just -l

build:
	@cd ./eperusteet/ && mvn clean install

clean:
	@cd ./eperusteet/ && mvn clean compile

gen_kooste:
	nim c -d:ssl -r ./tools/misc/kooste.nim

gen_schema:
	@cd ./eperusteet/eperusteet-service && mvn -P oph -o clean compile hibernate4:export -o|$EDITOR -

sync_localisations:
	@node ./tools/lokalisointi/sync_locales.js eperusteet/eperusteet-app/yo/app/localisation

# Generoi lista puutteellisista osaamisaloista
gen_puutteelliset_osaamisalat:
	@cd scripts && yarn install
	@cd scripts && yarn run puutteelliset-osaamisalat

# Generoi ammattitaitovaatimuskoodiston julkaistujen kohdealueiden perusteella
gen_ammattitaitovaatimuskoodisto:
	@cd scripts && yarn install
	@cd scripts && yarn run ammattitaitovaatimuskoodisto
