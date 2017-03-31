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

## Results

On my Dell XPS with 4 cores - no guarantess running your own :)

### Capybara

```
Warming up --------------------------------------
 fill_in text field    23.000  i/100ms
        visit forms     1.000  i/100ms
     find by css id    94.000  i/100ms
Calculating -------------------------------------
 fill_in text field    239.736  (± 8.8%) i/s -      4.301k in  18.085690s
        visit forms      9.622  (± 0.0%) i/s -    174.000  in  18.086288s
     find by css id    981.868  (±14.4%) i/s -     17.296k in  18.065214s
Comparison:
     find by css id:      981.9 i/s
 fill_in text field:      239.7 i/s - 4.10x  slower
        visit forms:        9.6 i/s - 102.04x  slower
```

### Wallaby

```
Erlang/OTP 19 [erts-8.2] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]
Elixir 1.4.2
Benchmark suite executing with the following configuration:
warmup: 2.0s
time: 18.0s
parallel: 1
inputs: none specified
Estimated total run time: 60.0s
Benchmarking fill_in text_field...
Benchmarking find by css #id...
Benchmarking visit forms...
Generated benchmarks/html/wallaby.html
Name                         ips        average  deviation         median
visit forms                 7.91      126.43 ms    ±32.60%      104.05 ms
find by css #id             5.29      188.87 ms     ±3.34%      188.06 ms
fill_in text_field          2.53      394.60 ms     ±2.47%      396.18 ms
Comparison:
visit forms                 7.91
find by css #id             5.29 - 1.49x slower
fill_in text_field          2.53 - 3.12x slower
```
