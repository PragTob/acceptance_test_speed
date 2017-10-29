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
tobi@speedy ~/github/acceptance_test_speed $ mix run benchmarks/elixir.exs
Compiling 1 file (.ex)
warning: String.to_char_list/1 is deprecated, use String.to_charlist/1
  lib/simple_server.ex:6

warning: String.to_char_list/1 is deprecated, use String.to_charlist/1
  lib/simple_server.ex:7

Generated acceptance_test_speed app
Operating System: Linux
CPU Information: Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
Number of Available Cores: 8
Available memory: 15.61 GB
Elixir 1.5.2
Erlang 20.0
Benchmark suite executing with the following configuration:
warmup: 2 s
time: 18 s
parallel: 1
inputs: filling a form field, find css by id, visit url
Estimated total run time: 6 min


# ...

##### With input filling a form field #####
Name              ips        average  deviation         median         99th %
hound            7.28      137.30 ms     ±1.62%      136.02 ms      144.03 ms
wallaby          2.79      358.74 ms     ±1.13%      356.10 ms      376.06 ms

Comparison:
hound            7.28
wallaby          2.79 - 2.61x slower

##### With input find css by id #####
Name              ips        average  deviation         median         99th %
hound           22.63       44.18 ms     ±1.95%       44.00 ms       48.01 ms
wallaby          5.66      176.66 ms     ±1.04%      176.00 ms      187.55 ms

Comparison:
hound           22.63
wallaby          5.66 - 4.00x slower

##### With input visit url #####
Name              ips        average  deviation         median         99th %
hound           19.02       52.59 ms     ±2.69%       52.01 ms       56.06 ms
wallaby         10.35       96.66 ms     ±1.65%       96.00 ms      103.97 ms

Comparison:
hound           19.02
wallaby         10.35 - 1.84x slower
```
