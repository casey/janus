set shell := ['pwsh', '-c']

_: just-fzf

just-fzf:
    (just --summary) -split " " | fzf | % {Write-Host "Choose Recipe :", $_ ; just $_}

just-list:
    just --list

fzf-help:
    fzf --help

info-fzf:
    % {if ("{{os()}}" -eq "windows") {scoop info fzf}}
    % {if ("{{os()}}" -eq "macos") {brew info fzf}}
