#!/usr/bin/env just --justfile

repository-local-path := `while r=$(ghq list --full-path "${repository_remote}") && [[ -z "${r}" ]] ; do ghq get --update "${repository_remote}" >/dev/null; done; echo "${r}"`
pyenv-version-name := `pyenv version-name`
literate-git-site-packages := `/usr/local/opt/literate-git/libexec/bin/python  -c 'import site; print(site.getsitepackages()[0])'`

repository-local-path:
    echo "${repository_remote}"
    echo "{{ repository-local-path }}"

checkout-branch:
    echo "${repository_remote}"
    echo "{{ repository-local-path }}"
    echo "${base_commit}"
    echo "${linear_commit}"
    echo "${tree_commit}"
    if [[ -n "${base_commit}" ]] ; then \
        if git --git-dir "{{ repository-local-path }}/.git" show-branch "${base_commit}" ; then : ; else \
            if git --git-dir "{{ repository-local-path }}/.git" show-branch "origin/${base_commit}" ; then \
                git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" checkout "${base_commit}" ; \
            fi ; \
        fi ; \
    fi ;
    if [[ -n "${linear_commit}" ]] ; then \
        if git --git-dir "{{ repository-local-path }}/.git" show-branch "${linear_commit}" ; then : ; else \
            if git --git-dir "{{ repository-local-path }}/.git" show-branch "origin/${linear_commit}" ; then \
                git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" checkout "${linear_commit}" ; \
            fi ; \
        fi ; \
    fi ;
    if [[ -n "${tree_commit}" ]] ; then \
        if git --git-dir "{{ repository-local-path }}/.git" show-branch "${tree_commit}" ; then : ; else \
            if git --git-dir "{{ repository-local-path }}/.git" show-branch "origin/${tree_commit}" ; then \
                git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" checkout "${tree_commit}" ; \
            fi ; \
        fi ; \
    fi ;
    git --git-dir "{{ repository-local-path }}/.git" --no-pager branch --list

dendrify:
    echo "{{ repository-local-path }}"
    echo "{{ pyenv-version-name }}"
    echo "${base_commit}"
    echo "${linear_commit}"
    echo "${tree_commit}"
    if [[ -n "${base_commit}" && -n "${linear_commit}" && -n "${tree_commit}" ]]; then \
        cd "{{ repository-local-path }}" && \
            pyenv local "{{ pyenv-version-name }}" && \
            git dendrify dendrify "${tree_commit}" "${base_commit}" "${linear_commit}" && \
            pyenv local --unset ; \
    fi

cache:
    if [[ ! -f ./cache/literate-git.css ]]; then \
        cd ./cache ; \
        wget --no-check-certificate https://raw.githubusercontent.com/bennorth/literate-git/develop/literategit/literate-git.css ; \
    fi
    if [[ ! -f ./cache/literate-git.js ]]; then \
        cd ./cache ; \
        wget --no-check-certificate https://raw.githubusercontent.com/bennorth/literate-git/develop/literategit/literate-git.js ; \
    fi
    if [[ ! -f ./cache/github-markdown.css ]]; then \
        cd ./cache ; \
        wget --no-check-certificate https://raw.githubusercontent.com/sindresorhus/github-markdown-css/gh-pages/github-markdown.css ; \
    fi
    if [[ ! -f ./cache/jquery-3.0.0.min.js ]]; then \
        cd ./cache ; \
        wget --no-check-certificate https://code.jquery.com/jquery-3.0.0.min.js ; \
    fi

literate-render: cache
    echo "{{ repository-local-path }}"
    echo "{{ literate-git-site-packages }}"
    echo "${base_commit}"
    echo "${tree_commit}"
    echo "${title}"
    echo "${output}"
    mkdir -p "${output}"
    cd "{{ repository-local-path }}" && \
        ln -f -s "{{ literate-git-site-packages }}/literategit/example_create_url.py" . && \
        git literate-render "${title}" "${base_commit}" "${tree_commit}" example_create_url.CreateUrl > "${output}/index.html" && \
        unlink ./example_create_url.py
    cp ./cache/* "${output}"

file-server:
    echo "${output}"
    caddy file-server --root "${output}"