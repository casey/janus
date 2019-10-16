bin_name := 'imgtool.py'

alias r := run
alias build := testrun # in case vim calls it
alias install := testrun # in case vim calls it

# Run with optional args
run +args='':
	./{{bin_name}} {{args}}

testrun:
    ./{{bin_name}} test/sunset.jpg test/sunset_edited.jpg -vv -mw 2000
