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

On my home computer with 4 "real" cores - no guarantess running your own :)

### Capybara

```
tobi@speedy ~/github/acceptance_test_speed $ ruby benchmarks/capybara.rb
Warming up --------------------------------------
 fill_in text field    31.000  i/100ms
        visit forms     1.000  i/100ms
     find by css id   126.000  i/100ms
Calculating -------------------------------------
 fill_in text field    314.732  (± 5.4%) i/s -      5.673k in  18.076096s
        visit forms      9.819  (± 0.0%) i/s -    177.000  in  18.029034s
     find by css id      1.265k (± 5.4%) i/s -     22.806k in  18.086122s
Comparison:
     find by css id:     1264.7 i/s
 fill_in text field:      314.7 i/s - 4.02x  slower
        visit forms:        9.8 i/s - 128.81x  slower
```

### Elixir (Hound and Wallaby)

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
