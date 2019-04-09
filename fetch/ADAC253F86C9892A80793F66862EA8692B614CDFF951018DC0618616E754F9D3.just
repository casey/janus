# run import program on list_movies.json
default:
    ./imp.sh

# search torrents for matching title, output to pager/most
search TERM:
    ./search.sh "{{TERM}}"

# search torrents for matching title, output to STDOUT not pager
searchb TERM:
    ./search.sh --cron "{{TERM}}"

recent:
    @sqlite3 yify.sqlite "select title, imdbid, year, genres from yify order by rowid desc limit 25" | tr '|' '\t' | column -t -s$'\t'

latest:
    @sqlite3 yify.sqlite "select title, year, url, genres, date_uploaded from yify order by year desc limit 25;" | tr '|' '\t' | column -t -s$'\t'
