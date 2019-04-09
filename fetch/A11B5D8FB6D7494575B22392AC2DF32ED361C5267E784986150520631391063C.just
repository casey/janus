# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :

# download events file. 
# This is used for getting the links of results only.
events yyyy='':
	#!/usr/bin/env bash 
	year="{{yyyy}}"

	if [[ -z $year ]]; then
	    year=$(date +"%Y")
	fi

	mkdir -p in/$year/events
	OUTDIR=in/$year/events
	OUTFILE=$OUTDIR/$year.html
	GZOUTFILE=$OUTFILE.gz
	wget -O $GZOUTFILE https://www.atptour.com/en/scores/results-archive?year=$year
	file $GZOUTFILE
	gunzip $GZOUTFILE
	wc -l $OUTFILE

# reads the events file for given year and creates event listing in out/YYYY/events/YYYY.tsv
calendar yyyy='':
	#!/usr/bin/env bash 
	year="{{yyyy}}"

	if [[ -z $year ]]; then
	    year=$(date +"%Y")
	fi
	OUTDIR=out/$year/events
	mkdir -p out/$year/events
	OUT=out/$year/calendar-${year}.tsv
	# this creates two lines per record: title, date
	sed -n '/span class="tourney-title"/,/<\/span>/p;/span class="tourney-location"/,/<\/span>/p;/span class="tourney-dates"/,/<\/span>/p;' in/$year/events/$year.html | grep -v '^ *<' | sed  's/ *<\/span>//;s/^ *//' > events.t
	head events.t
	# For some strange reason, paste puts a Ctrl-M which needs to be removed
	# This is a tab delimited file
	# remove dot from dates so we can compare dates using awk
	paste  - - - < events.t | tr -d '' | tr -d '.' > ${OUT}
	rm events.t
	echo created ${OUT}
	wc -l ${OUT}

	filename="$OUT"
	while IFS='' read -r line || [[ -n "$line" ]]; do
		date=$(echo "$line" | cut -f3 | tr -d '.')
		location=$(echo "$line" | cut -f2 )
		title=$(echo "$line" | cut -f1 )
		name=$(echo "$line" | cut -f2 | tr '[A-Z]' '[a-z]' | cut -f1 -d, | tr ' ' '-' | tr -d '.' )
		#echo "date is $date"
		#echo "name is $name"
		echo "$title	$location" > $OUTDIR/${date}_${name}.txt
		#echo "line is $line"
	done < "$filename"
	

# Download links for the year
# We could compare links with existing file of links to see if any new ones. I guess current one
# would become archive each month/week ?
event_links yyyy='':
	#!/usr/bin/env bash 
	year="{{yyyy}}"

	if [[ -z $year ]]; then
	    year=$(date +"%Y")
	fi

	INDIR=in/$year/events
	INFILE=$INDIR/$year.html
	if [[ ! -f $INFILE ]]; then
		echo "$INFILE not yet downloaded"
		exit 1
	fi
	# links can be in two formats
	# link is /en/scores/archive/auckland/301/2019/results
	# link is /en/scores/current/australian-open/580/live-scores
	grep -o '/en/scores/archive.*results"' $INFILE | tr -d '"' > event_links.txt
	grep -o '/en/scores/current.*live-scores"' $INFILE | tr -d '"' >> event_links.txt
	HOST="https://www.atptour.com/"
	counter=0
	for link in $(cat event_links.txt); do
		echo link is $link
		IFS='/' read -ra ADDR <<< "$link"
		if [[ $link = *archive* ]]; then
		  YEAR=${ADDR[6]}
		  CODE="${ADDR[4]}-${ADDR[5]}"
		elif [[ $link = *current* ]]; then
		  YEAR=$(date +"%Y")
		  CODE="${ADDR[4]}-${ADDR[5]}"
		fi
		OUTFILE=in/$YEAR/events/$CODE.html
		echo $OUTFILE
		GZOUTFILE=$OUTFILE.gz
		if [[ -f $OUTFILE ]]; then
			echo $OUTFILE exists
		else
			link="${HOST}${link}"
			echo Downloading $link to $OUTFILE
			wget --header="accept-encoding: gzip" -O $GZOUTFILE $link
			if [[ -f $GZOUTFILE ]]; then
				gunzip $GZOUTFILE
			fi
			((counter++))
		fi
		echo "$counter files were downloaded"
		# check if file exists, ignore else download
	done

# list recent events
complete yyyy='':
	#!/usr/bin/env bash
	year="{{yyyy}}"

	if [[ -z $year ]]; then
	    year=$(date +"%Y")
	fi
	IN=out/$year/calendar-$year.tsv
	TODAY=$(date +"%Y%m%d")
	gawk -F'\t' "{ if( \$3 < $TODAY) { print \$0;} }" $IN | column -t -s$'\t'

# list upcoming events
upcoming yyyy='':
	#!/usr/bin/env bash
	year="{{yyyy}}"

	if [[ -z $year ]]; then
	    year=$(date +"%Y")
	fi
	IN=out/$year/calendar-$year.tsv
	TODAY=$(date +"%Y%m%d")
	(( NWEEK = $TODAY + 10 ))
	echo $NWEEK
	gawk -F'\t' "{ if( \$3 > $TODAY && \$3 < $NWEEK) { print \$0;} }" $IN | column -t -s$'\t'

