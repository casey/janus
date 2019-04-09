# janus

Janus is a tool for collecting and analyzing justfiles on GitHub,
inspired by [Crater](https://github.com/rust-lang-nursery/crater).

If you would prefer your justfile not appear in this repo, let me
know and I'll purge it.

## search

Search for justfiles on github and download hits to `search/TIMESTAMP/PAGE.yaml`.

Requires a user session key, because GitHub doesn't allow site-wide searches via
the API, so we are reduced to screen scraping the search page like a wretched
animal.

`janus search USER-SESSION-KEY`

## fetch

Download justfiles found by search to `fetch/SHA-256.just`.

`janus fetch` 

## analyze

Analyze justfiles downloaded by fetch. It parses justfiles with `v0.4.1` and a
local development copy of just, and compares the results.

`janus analyze`
