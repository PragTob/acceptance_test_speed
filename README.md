# Acceptance Test Speed

A benchmark showing how fast certain operations are with different Acceptance/Feature/Ende2End/"whatever you call them" libraries.

All of them use phantomjs, to be fair of course :)

More specific:

* [capybara](https://github.com/teamcapybara/capybara) with [poltergeist](https://github.com/teampoltergeist/poltergeist) (ruby)
* [wallaby](https://github.com/keathley/wallaby) (elixir)
* [hound](https://github.com/HashNuke/hound) (elixir) - benchmark not yet working due to an issue with session management


## Installation

```
npm install -g phantomjs-prebuilt
mix deps.get
bundle install
```

## Running

Benchmarks are located in in `benchmarks`

```
mix run benchmarks/wallaby.exs
```

```
mix run --no-halt server_start.exs # same server running for fairness
ruby benchmarks/capybara.rb
```
