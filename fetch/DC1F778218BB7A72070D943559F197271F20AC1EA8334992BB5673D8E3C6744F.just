_default: toast-tasks

toast-tasks:
    if [ -e output/output.sh ]; then \
        rm output/output.sh; \
    fi
    toast toast-tasks | \
        /usr/local/opt/choose-gui/bin/choose | \
        gawk '{print gensub(/^([^ ]*).*$/, "\\1", "g");}' | \
        while read line; do \
            echo "Choose Task : " "${line}"; \
            toast "${line}"; \
        done;
    if [ -e output/output.sh ]; then \
        chmod u+x "output/output.sh"; \
        "output/output.sh"; \
    fi

root_dir := `pwd`
draft_dir := `jump cd toast-draft`
code_workspace := root_dir + '/toast.code-workspace'

just-evaluate:
    just --evaluate

just-draft-dir:
    echo "{{draft_dir}}"

code:
    if [ -f '{{code_workspace}}' ]; then \
        code '{{code_workspace}}'; \
    else \
        code '{{root_dir}}'; \
    fi