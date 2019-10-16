bin_name := 'pyimg'
test_file_in := 'test/sunset.jpg'
test_file_out := 'test/sunset_edited.jpg'
test_watermark_file := 'test/logo.png'

alias r := runargs
alias run := runtest
alias h := help
alias build := runtest # in case vim calls it
alias install := runtest # in case vim calls it

# Run with optional args
runargs +args='':
	{{bin_name}} {{test_file_in}} {{test_file_out}} {{args}}

# test
runtest:
    {{bin_name}} {{test_file_in}} {{test_file_out}} -vv -mw 2000

# test watermark image
runwi +args='':
    {{bin_name}} {{test_file_in}} {{test_file_out}} -v -mw 2000 -mh 2000 -wi {{test_watermark_file}} {{args}}

# show prog help
help:
    {{bin_name}} -h
