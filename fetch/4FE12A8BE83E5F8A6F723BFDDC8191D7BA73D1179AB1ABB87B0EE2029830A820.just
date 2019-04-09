#
# justfile: automation tasks using the `just` package
#

default: test


ALL_FEATURES = "mods_db"

build +ARGS='':
	cargo build {{ARGS}} --features="{{ALL_FEATURES}}"
clean:
	cargo clean
doc:
	cargo doc --open
test:
    cargo test --no-fail-fast --features="{{ALL_FEATURES}}"


# Update the content of JSON data files by re-downloading it
# from the static data endpoint in PoE API.
update: update-data update-mods

update-data: update-currencies update-maps update-cards
DATA_URL = "https://www.pathofexile.com/api/trade/data/static"
update-currencies:
	curl {{DATA_URL}} 2>/dev/null | jq '.["result"]["currency"]' >./data/currency.json
update-maps:
	curl {{DATA_URL}} 2>/dev/null | jq '.["result"]["maps"]' >./data/maps.json
update-cards:
	curl {{DATA_URL}} 2>/dev/null | jq '.["result"]["cards"]' >./data/cards.json

# TODO: merge the update-*-mods tasks to not download the affix file five times
update-mods: update-pseudo-mods update-explicit-mods update-implicit-mods update-enchant-mods update-crafted-mods
MODS_URL = "https://www.pathofexile.com/api/trade/data/stats"
update-pseudo-mods:
	curl {{MODS_URL}} 2>/dev/null | jq '.["result"][0]["entries"]' >./data/mods/pseudo.json
update-explicit-mods:
	curl {{MODS_URL}} 2>/dev/null | jq '.["result"][1]["entries"]' >./data/mods/explicit.json
update-implicit-mods:
	curl {{MODS_URL}} 2>/dev/null | jq '.["result"][2]["entries"]' >./data/mods/implicit.json
update-enchant-mods:
	curl {{MODS_URL}} 2>/dev/null | jq '.["result"][3]["entries"]' >./data/mods/enchant.json
update-crafted-mods:
	curl {{MODS_URL}} 2>/dev/null | jq '.["result"][4]["entries"]' >./data/mods/crafted.json
