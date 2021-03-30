author := `git config --get user.name`
year := `date +%Y`
bin_or_lib := 'bin'

rs name type=bin_or_lib:
    #!/bin/bash
    if [[ {{type}} != "lib" ]]; then
        cargo new {{name}}
        cd {{invocation_directory()}}/{{name}}
        blindfold --lang rust
        sed -i 's/Cargo.lock/#Cargo.lock/' .gitignore
    else
        cargo new --lib {{name}}
        cd {{invocation_directory()}}/{{name}}
        blindfold --lang rust
    fi
    license-generator MIT Apache --author "{{author}}" --project {{name}} --year {{year}}
    
    cp ~/.config/git/journal/gitjournal.toml .gitjournal.toml
    cp ~/.config/git/journal/_git-journal .
    cp ~/.config/git/journal/git-journal.bash .
    cp -f ~/.config/just/hooks/rust/* {{invocation_directory()}}/{{name}}/.git/hooks
    chmod +x {{invocation_directory()}}/{{name}}/.git/hooks/pre-commit
    chmod +x {{invocation_directory()}}/{{name}}/.git/hooks/pre-push

    echo "# {{name}}" > README.md
    echo " " >> README.md
    echo "[![License](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE)" >> README.md
    echo " " >> README.md
    echo "Dual-licensed under MIT or the Apache-2.0" >> README.md
    echo " " >> README.md