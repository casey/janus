build:
    python generate_viola.py
    lilypond -o output -djob-count=4 violin.ly viola.ly

clean:
    rm **/*.pdf

number WORD NUMERAL:
    python make_number.py {{WORD}} {{NUMERAL}}   
    git add 'notes/{{WORD}}.ily'

commit MESSAGE:
    just build
    git commit -sam "{{MESSAGE}}"
