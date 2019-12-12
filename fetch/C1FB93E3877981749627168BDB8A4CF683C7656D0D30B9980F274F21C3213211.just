# https://github.com/casey/just
# run import program on list_movies.json
# After this Insert new movies into imdb database using sync.
default:
    ./imp.sh

# download imdb data for new entries and insert into imdb database
# f.sh returns an exit status of 1 if file exists.
# Run this after running the default
sync:
    @sqlite3 yify.sqlite "SELECT imdbid, genres FROM yify ORDER BY rowid DESC LIMIT 25" | grep -v 'Horror' | cut -f1 -d '|' | tr '\n' ' ' | xargs ~/bin/src/f.sh

synctest:
    @sqlite3 yify.sqlite "SELECT imdbid, genres FROM yify ORDER BY rowid DESC LIMIT 25" | grep -v 'Horror' | cut -f1 -d '|' | tr '\n' ' '

# Generate database of yify titles that have not been inserted into imdb database
missing:
  ./attachimdbttcode.sh

# search torrents for matching title, output to pager/most
search TERM:
    ./search.sh "{{TERM}}"

# search torrents for matching title, output to STDOUT not pager
searchb TERM:
    ./search.sh --cron "{{TERM}}"

# recently uploaded last 25
recent:
    @sqlite3 yify.sqlite "select title, imdbid, year, rating, genres from yify order by rowid desc limit 25" | tr '|' '\t' | column -t -s$'\t'

# ordered by year, last 25
latest:
    @sqlite3 yify.sqlite "select title, imdbid, year, genres, url, date_uploaded from yify order by year desc limit 25;" | tr '|' '\t' | column -t -s$'\t'

# search on genre, order by year desc
genre TERM:
    @sqlite3 yify.sqlite "SELECT title, imdbid, year, genres, rating FROM yify WHERE genres like '%{{TERM}}%' ORDER BY year DESC LIMIT 200 ;" | tr '|' '\t' | column -t -s$'\t'
