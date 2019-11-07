server = ""
cache-dir = "/data1/acs-cache"
out-dir = "$HOME/out/datausa-acs-out"
database = "datausa"
user = "deploy"


# Make sure that .envrc is updated to use correct acs host!
# This it the default run-everythin recipe for datausa.
# mean-transportation goes last, it needs to overwrite some files from regular ingest
# Need to double check, why does mean transportation load fail if the table already exist
# from the "Incorrect" load from before?
ingest-monet: cubes
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} process --years "2013-"
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} sql --schema acs
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} load --schema acs --database datausa --dbms monet
    mclient -h {{server}}-api.datausa.io -d datausa -s 'drop table acs.acs_ygt_mean_transportation_time_to_work_1'
    mclient -h {{server}}-api.datausa.io -d datausa -s 'drop table acs.acs_ygt_mean_transportation_time_to_work_5'
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} --mean-transportation process --years "2013-"
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} --mean-transportation load --schema acs --database datausa --dbms monet

one-db-ingest-monet configpath:
    acs-pipe -f {{configpath}} --cache-dir={{cache-dir}} --out-dir={{out-dir}} process --years "2013-"
    acs-pipe -f {{configpath}} --cache-dir={{cache-dir}} --out-dir={{out-dir}} sql --schema acs
    acs-pipe -f {{configpath}} --cache-dir={{cache-dir}} --out-dir={{out-dir}} load --schema acs --database datausa --dbms monet

fetch-latest year="2017":
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} fetch --years "{{year}}-{{year}}"

ingest-postgres: cubes
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} process --years "2013-"
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} sql --schema acs
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} load --schema acs --database {{database}} --dbms psql
    psql -h {{server}}-api.datausa.io -d {{database}} -U {{user}} -c 'drop table acs.acs_ygt_mean_transportation_time_to_work_1'
    psql -h {{server}}-api.datausa.io -d {{database}} -U {{user}} -c 'drop table acs.acs_ygt_mean_transportation_time_to_work_5'
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} --mean-transportation process --years "2013-"
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} --mean-transportation load --schema acs --database {{database}} --dbms psql

ingest-mean-transportation-monet:
    acs-pipe --mean-transportation process --years "2013-"
    acs-pipe --mean-transportation sql --schema acs
    acs-pipe --mean-transportation load --schema acs --database datausa

ingest-mean-transportation-postgres:
    acs-pipe --mean-transportation process --years "2013-"
    acs-pipe --mean-transportation load --schema acs --database datausa --dbms psql

smooth:
    acs-pipe -f prelim-config/B24010.yaml config smooth --strategy pushdown --start-index 1 > acs-config/ygio/B24010.yaml
    acs-pipe -f prelim-config/B24011.yaml config smooth --strategy non-agg  --start-index 0 > acs-config/ygio/B24011.yaml
    acs-pipe -f prelim-config/B24012.yaml config smooth --strategy non-agg  --start-index 1 > acs-config/ygio/B24012.yaml
    acs-pipe -f prelim-config/B24030.yaml config smooth --strategy pushdown --start-index 1 > acs-config/ygio/B24030.yaml
    acs-pipe -f prelim-config/B24031.yaml config smooth --strategy non-agg  --start-index 0 > acs-config/ygio/B24031.yaml
    acs-pipe -f prelim-config/B24032.yaml config smooth --strategy non-agg  --start-index 1 > acs-config/ygio/B24032.yaml
    acs-pipe -f prelim-config/C24010.yaml config smooth --strategy pushdown --start-index 1 > acs-config/ygio/C24010.yaml
    acs-pipe -f prelim-config/C24030.yaml config smooth --strategy pushdown --start-index 1 > acs-config/ygio/C24030.yaml

process-cubes:
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} mondrian cube --db-schema acs --mondrian-schema datausa
    acs-pipe --cache-dir={{cache-dir}} --out-dir={{out-dir}} --mean-transportation mondrian cube --db-schema acs --mondrian-schema datausa

remove-empty-cubes:
    rm {{out-dir}}/acs_ygh_households_with_no_internet_5.xml
    rm {{out-dir}}/acs_ygh_renters_by_income_percentage_c_5.xml
    rm {{out-dir}}/acs_ygso_gender_by_occupation_5.xml
    rm {{out-dir}}/acs_ygsi_gender_by_industry_5.xml

upload-schema:
    scp {{out-dir}}/*.xml {{server}}:~/datausa-mondrian/frags/acs/.

multi-table-cubes-annotate:
    sed -i -E 's/"table_id">B27.+</"table_id">B27001,B27002,B27003,B27004,B27005,B27006,B27007,B27008,B27009</g' {{out-dir}}/acs_yghsa_health_coverage_type_by_gender_by_age_5.xml
    sed -i -E 's/"table_id">B17.+</"table_id">B17001,B17001A,B17001B,B17001C,B17001D,B17001E,B17001F,B17001G,B17001H</g' {{out-dir}}/acs_ygpsar_poverty_by_gender_age_race_1.xml
    sed -i -E 's/"table_id">B17.+</"table_id">B17001,B17001A,B17001B,B17001C,B17001D,B17001E,B17001F,B17001G,B17001H</g' {{out-dir}}/acs_ygpsar_poverty_by_gender_age_race_5.xml
    sed -i -E 's/"table_id">B19.+</"table_id">B19013,B19013A,B19013B,B19013C,B19013D,B19013E,B19013F,B19013G,B19013H</g' {{out-dir}}/acs_ygr_median_household_income_race_1.xml
    sed -i -E 's/"table_id">B19.+</"table_id">B19013,B19013A,B19013B,B19013C,B19013D,B19013E,B19013F,B19013G,B19013H</g' {{out-dir}}/acs_ygr_median_household_income_race_5.xml
    sed -i -E 's/"table_id">B08.+</"table_id">B08006,B08013</g' {{out-dir}}/acs_ygt_mean_transportation_time_to_work_1.xml
    sed -i -E 's/"table_id">B08.+</"table_id">B08006,B08013</g' {{out-dir}}/acs_ygt_mean_transportation_time_to_work_5.xml

# osx sed
#multi-table-cubes-annotate-osx:
#    sed -i '' -E 's/"table_id">B27.+</"table_id">B27001,B27002,B27003,B27004,B27005,B27006,B27007,B27008,B27009</g' {{out-dir}}/acs_yghsa_health_coverage_type_by_gender_by_age_5.xml
#    sed -i '' -E 's/"table_id">B17.+</"table_id">B17001,B17001A,B17001B,B17001C,B17001D,B17001E,B17001F,B17001G,B17001H</g' {{out-dir}}/acs_ygpsar_poverty_by_gender_age_race_1.xml
#    sed -i '' -E 's/"table_id">B17.+</"table_id">B17001,B17001A,B17001B,B17001C,B17001D,B17001E,B17001F,B17001G,B17001H</g' {{out-dir}}/acs_ygpsar_poverty_by_gender_age_race_5.xml
#    sed -i '' -E 's/"table_id">B19.+</"table_id">B19013,B19013A,B19013B,B19013C,B19013D,B19013E,B19013F,B19013G,B19013H</g' {{out-dir}}/acs_ygr_median_household_income_race_1.xml
#    sed -i '' -E 's/"table_id">B19.+</"table_id">B19013,B19013A,B19013B,B19013C,B19013D,B19013E,B19013F,B19013G,B19013H</g' {{out-dir}}/acs_ygr_median_household_income_race_5.xml
#    sed -i '' -E 's/"table_id">B08.+</"table_id">B08006,B08013</g' {{out-dir}}/acs_ygt_mean_transportation_time_to_work_1.xml
#    sed -i '' -E 's/"table_id">B08.+</"table_id">B08006,B08013</g' {{out-dir}}/acs_ygt_mean_transportation_time_to_work_5.xml


cubes: process-cubes remove-empty-cubes multi-table-cubes-annotate upload-schema
    echo "finished processing and uploading cubes"

cubes-local: process-cubes remove-empty-cubes
    echo "finished processing cubes"

#process-example:
#  acs-pipe -f acs-config/ygio/B24011.yaml process --years "2015-"
#  acs-pipe -f acs-config/ygio/B24011.yaml sql --schema acs
#  acs-pipe -f acs-config/ygio/B24011.yaml load --schema acs --database datausa
#  acs-pipe -f acs-config/ygio/B24011.yaml mondrian cube --db-schema acs --mondrian-schema datausa --stdout

#clear-ygio-tables:
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygso_gender_by_occupation_for_median_earnings_1'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygso_gender_by_occupation_for_median_earnings_5'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygso_gender_by_occupation_c_1'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygso_gender_by_occupation_c_5'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygsi_gender_by_industry_c_1'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygsi_gender_by_industry_c_5'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygo_occupation_for_median_earnings_1'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygo_occupation_for_median_earnings_5'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygso_gender_by_occupation_1'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygso_gender_by_occupation_5'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygsi_gender_by_industry_1'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygsi_gender_by_industry_5'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygi_industry_for_median_earnings_1'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygi_industry_for_median_earnings_5'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygsi_gender_by_industry_for_median_earnings_1'
#    mclient -h canon-api.datausa.io -d datausa -s 'drop table acs.acs_ygsi_gender_by_industry_for_median_earnings_5'
#
#ygio-ingest:
#    time acs-pipe -m "acs-config/ygio/*" process --years "2013-"
#    time acs-pipe -m "acs-config/ygio/*" sql --schema acs
#    time acs-pipe -m "acs-config/ygio/*" load --schema acs --database datausa

#process-example:
#  acs-pipe -f acs-config/ygio/B24031.yaml process --years "2015-"
#  acs-pipe -f acs-config/ygio/B24031.yaml sql --schema acs
#  acs-pipe -f acs-config/ygio/B24031.yaml load --schema acs --database datausa
#  acs-pipe -f acs-config/ygio/B24031.yaml mondrian cube --db-schema acs --mondrian-schema datausa --stdout

#add-metadata:
#  find acs-config/* -type f -exec sh -c "echo \"metadata:\n  topic: Diversity\n  subtopic: Heritage\n  units_of_measure: People\" >> {}" \;
#  find acs-config/* -type f -exec vim -p {} +

get-annotations:
    ripgrep --no-filename --only-matching 'Annotation name=".+"' | runiq -

missing-geo:
    rm -f missing-geo/migrate-geo.csv
    cat missing-geo/missing-geo.csv | tr '\n' '\0' | xargs -0 -I {} sh -c "curl -L https://api.datausa.io/attrs/geo/{}/ | rg data | jq -r '.data[0] | \"\\(.[1]);\\(.[8])\"' >> missing-geo/migrate-geo.csv"

test-default-member:
    cp ../acs-etl-rs/mondrian-templates/* mondrian-templates/.
    just cubes-local
    rg defaultMember acs-out

# xsv select -d ';' 2,3 migrate-geo-map.csv | xsv search -s 2 "310|050" > migrate-geo-final.csv
# find * -type f -exec sh -c 'echo geos: [\\n"    place,"\\n"    county,"\\n"    state,"\\n"    msa,"\\n"    puma,"\\n"    nation"\\n]>> {}' \;

open-configs search:
    vim -p `rg {{search}} -l acs-config | tr '\n' ' '`
