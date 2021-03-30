#!/usr/bin/env just --justfile

repository-local-path := `while r=$(ghq list --full-path "${repository_remote}") && [[ -z "${r}" ]] ; do ghq get --update "${repository_remote}" >/dev/null; done; echo "${r}"`
literate-git-branch-prefix := 'literate-git-'
literate-git-linear-branch-prefix := literate-git-branch-prefix + 'linear-'
literate-git-linear-branch := literate-git-linear-branch-prefix + `echo "${linear_branch_postfix}"`
linear-branch := literate-git-linear-branch
literate-git-tree-branch-prefix := literate-git-branch-prefix + 'tree-'
literate-git-tree-branch := literate-git-tree-branch-prefix + `echo "${tree_branch_postfix}"`
tree-branch := literate-git-tree-branch
pyenv-version-name := `pyenv version-name`
literate-git-site-packages := `/usr/local/opt/literate-git/libexec/bin/python  -c 'import site; print(site.getsitepackages()[0])'`

repository-local-path:
    echo "${repository_remote}"
    echo "{{ repository-local-path }}"

show-commit-message:
    echo "{{ repository-local-path }}"
    echo "${commit_message_path}"
    cd "{{ repository-local-path }}" && \
        cd "${commit_message_path}" && \
        pwd && \
        find . -type f | sort --version-sort | while read line ; do \
            echo "${line}" | pastel paint --bold red --no-newline && \
            branch_name="$(echo "${line}" | sed 's/^\.[/][^/]*[/]\(.*\)\.[^.]*$/\1/')" && \
            echo "${branch_name}" && \
            if git --git-dir "{{ repository-local-path }}/.git" show-branch --sha1-name "${branch_name}" ; then \
                commit_content="$(cat "${line}")" && \
                echo "${commit_content}" ; \
            fi \
        done

regenerate-linear-branch:
    echo "{{ repository-local-path }}"
    echo "${base_branch}"
    echo "{{ literate-git-linear-branch }}"
    echo "${commit_message_path}"
    if git --git-dir "{{ repository-local-path }}/.git" show-branch "{{ literate-git-linear-branch }}" ; then \
        git --git-dir "{{ repository-local-path }}/.git" branch --delete --force "{{ literate-git-linear-branch }}" ; \
    fi
    git --git-dir "{{ repository-local-path }}/.git" branch --copy "${base_branch}" "{{ literate-git-linear-branch }}"
    cd "{{ repository-local-path }}" && \
        cd "${commit_message_path}" && \
        pwd && \
        find . -type f | sort --version-sort | while read line ; do \
            echo "${line}" | pastel paint --bold red --no-newline && \
            branch_name="$(echo "${line}" | sed 's/^\.[/][^/]*[/]\(.*\)\.[^.]*$/\1/')" && \
            echo "${branch_name}" && \
            if git --git-dir "{{ repository-local-path }}/.git" show-branch --sha1-name "${branch_name}" ; then \
                cd "{{ repository-local-path }}" && \
                commit_content="$(cd "${commit_message_path}"; cat "${line}")" && \
                echo "${commit_content}" && \
                current_branch="$(git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" branch --show-current)" && \
                echo "${current_branch}" && \
                git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" checkout "{{ literate-git-linear-branch }}" && \
                git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" merge --squash --strategy-option=theirs "${branch_name}" && \
                git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" commit --allow-empty -m "${commit_content}" && \
                git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" checkout "${current_branch}" ; \
            fi \
        done

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
    echo "${base_branch}"
    echo "{{ linear-branch }}"
    echo "{{ literate-git-tree-branch }}"
    if [[ -n "${base_branch}" && -n "{{ linear-branch }}" && -n "{{ literate-git-tree-branch }}" ]]; then \
        if git --git-dir "{{ repository-local-path }}/.git" show-branch "{{ literate-git-tree-branch }}" ; then \
            git --git-dir "{{ repository-local-path }}/.git" branch --delete --force "{{ literate-git-tree-branch }}" ; \
        fi && \
        cd "{{ repository-local-path }}" && \
            python_version_original="$(pyenv local)" && \
            pyenv local "{{ pyenv-version-name }}" && \
            git dendrify dendrify "{{ literate-git-tree-branch }}" "${base_branch}" "{{ linear-branch }}" && \
            if [[ -n "${python_version_original}" ]]; then \
                pyenv local "${python_version_original}" ; \
            else \
                pyenv local --unset ; \
            fi \
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
    echo "${base_branch}"
    echo "{{ tree-branch }}"
    echo "${title}"
    echo "${output_path}"
    cd "{{ repository-local-path }}" && \
        mkdir -p "${output_path}"
    cd "{{ repository-local-path }}" && \
        ln -f -s "{{ literate-git-site-packages }}/literategit/example_create_url.py" . && \
        git literate-render "${title}" "${base_branch}" "{{ tree-branch }}" example_create_url.CreateUrl > "${output_path}/index.html" && \
        unlink ./example_create_url.py
    cp ./cache/* "$(cd "{{ repository-local-path }}"; cd "${output_path}"; pwd)"

all: regenerate-linear-branch dendrify literate-render

file-server:
    echo "{{ repository-local-path }}"
    echo "${output_path}"
    caddy file-server --root "$(cd "{{ repository-local-path }}"; cd "${output_path}"; pwd)"

github-pages:
    echo "{{ repository-local-path }}"
    echo "${output_path}"
    git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" checkout master
    if git --git-dir "{{ repository-local-path }}/.git" show-branch gh-pages ; then \
        git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" branch --delete --force gh-pages ; \
    fi
    git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" checkout --orphan gh-pages
    git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" rm -rf .
    cd "{{ repository-local-path }}" && \
        cd "${output_path}" && \
        find . -type f -exec mv {} ../ \; -exec git add ../{} \;
    git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" commit --message "GitHub Pages"
    git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" push --force --set-upstream origin gh-pages
    git --git-dir "{{ repository-local-path }}/.git" --work-tree "{{ repository-local-path }}" checkout master

push-tags:
    git push --tags --force