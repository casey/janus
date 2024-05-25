# janus

Janus is a tool for collecting and analyzing justfiles on GitHub, inspired by
[Crater](https://github.com/rust-lang-nursery/crater).

## search

Search for justfiles on github and download hits to
`search/TIMESTAMP/PAGE.yaml`.

Requires a user session key, because GitHub doesn't allow site-wide searches
via the API, so we are reduced to screen scraping the search page like a
wretched animal.

`janus search USER-SESSION-KEY`

## fetch

Download justfiles found by search to `fetch/SHA-256.just`.

`janus fetch`

## analyze

Analyze justfiles downloaded by fetch. It parses justfiles with both the latest
version of `just`, and a local development copy, and compares the results.

`janus analyze`
