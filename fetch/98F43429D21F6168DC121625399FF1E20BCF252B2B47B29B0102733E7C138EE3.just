# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :
# ----------------------------------------------------------------------------- #
#         File: justfile
#  Description: replacement of command.sh. Should be used henceforth.
#       Author: j kepler  http://github.com/mare-imbrium/canis/
#         Date: 2018-02-20 - 12:09
#      License: MIT
#  Last update: 2018-03-29 09:40
# ----------------------------------------------------------------------------- #
#  justfile  Copyright (C) 2018 j kepler
# taking this from command.sh
#

# check for duplicates by title and year
dupes:
    @echo "== checking duplicate title and year"
    sqlite3 movie.sqlite "select  title, year, count(*) from movie group by title, year having count(*) > 1;"
    @echo "== checking duplicate imdbids"
    sqlite3 movie.sqlite "select  imdbid, count(*) from movie group by imdbid having count(*) > 1;"

# dump database contents to csv file
dump:
    ./dump.sh


# fetch urls in given file (urls.txt)
fetch file="urls.txt":
    wc -l {{file}}
    ./fetchmovie.sh -f {{file}}

# fetch one wiki url
f url:
    ./fetchmovie.sh "{{url}}"
    # TODO extract imdbid and download that one in imdb database

# fetch urls in given file, even if already existing. Required to update, or if insert crashed
force_fetch file="urls.txt":
    wc -l {{file}}
    ./fetchmovie.sh --force -f {{file}}

# list the last 10 updates
recent n="10":
	sqlite3 --separator "	" movie.sqlite "select rowid, year, imdbid, create_dt, title from movie order by rowid desc limit {{n}}"

# sync this database with imdb database
sync:
    # first fix any duplicate imdb in imdbID field
    @echo "This gives a list of imdbids that don't exist in the imdbdata imdb.sqlite database"
    ./attachimdbttcode.sh
    @echo
    @echo "Remove any entries with multiple IMDB ids or fix them"
    @echo "Copy ./imdbmissing.tsv to imdbdata dir using only first column (imdbid). Rename to files.list"
    @echo "Goto imdbdata dir and run command.sh fetch"
    #cut -f1 ./imdbmissing.tsv
    cat ./imdbmissing.tsv

# add wiki page of actor
actor url:
	wiki/src/add_link_non_movie.sh -t actors "{{url}}"

# add wiki page of director
director url:
	wiki/src/add_link_non_movie.sh -t directors "{{url}}"
