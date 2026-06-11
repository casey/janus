# janus

Janus is a tool for collecting and analyzing justfiles on GitHub,
inspired by [Crater](https://github.com/rust-lang-nursery/crater).

## search

`janus search`

Search for justfiles on github and download hits to `search/TIMESTAMP/PAGE.yaml`.

## fetch

`janus fetch`

Download justfiles found by search to `fetch/<SHA_256>.just`.

## analyze

`janus analyze`

Analyze justfiles downloaded by fetch. It parses justfiles with `v0.4.1` and a
local development copy of just, and compares the results.
