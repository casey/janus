bin_name := 'pyimgtool'
test_file_in := 'test/sunset.jpg'
test_file_out := 'test/sunset_edited.jpg'
test_file_out2 := 'test/sunset_edited2.jpg'
test_watermark_file := 'test/logo.png'
test_full_watermark_file := 'test/logo_full.png'

alias r := runargs
alias run := runcv
alias h := help
alias build := runcv # in case vim calls it
alias install := runcv # in case vim calls it

# Run with optional args
runargs +args='':
	{{bin_name}} {{test_file_in}} {{test_file_out}} {{args}}

# test
runpil:
    {{bin_name}} -vv open {{test_file_in}} resize -s 0.4 save {{test_file_out}} -fk

runcv:
    {{bin_name}} -vv open {{test_file_in}} resize2 -s 0.4 save {{test_file_out2}} -fk

# test text watermark
runw +args='':
    {{bin_name}} {{test_file_in}} {{test_file_out}} -vf -mw 2000 -mh 2000 -tc "Nick Murphy | murphpix.com" {{args}}

# test logo watermark image
runwi +args='':
    {{bin_name}} {{test_file_in}} {{test_file_out}} -vf -mw 2000 -mh 2000 -wi {{test_watermark_file}} {{args}}

# test full logo watermark
runwif +args='':
    {{bin_name}} {{test_file_in}} {{test_file_out}} -vf -mw 2000 -mh 2000 -wi {{test_full_watermark_file}} {{args}}

# show prog help
help:
    {{bin_name}} -h

# create dist and upload to pypi
pack:
    rm -rf dist && python setup.py sdist bdist_wheel && twine upload dist/*

generate_tasks:
    #!/usr/bin/env python3
    from subprocess import run
    import re
    tasks = run(["just", "-l"], capture_output=True)
    tasks = [t.lstrip() for t in tasks.stdout.decode().split("\n")]
    splits = [re.split(r"\s+", t) for t in tasks if t != ""]
    print(splits)
