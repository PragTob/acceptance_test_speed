{:ok, server} = SimpleServer.start
Application.put_env(:wallaby, :base_url, server.base_url)

use Wallaby.DSL

{:ok, session} = Wallaby.start_session

session = visit(session, "forms.html")

text_field_query = Query.text_field("name")
id_css_query = Query.css("#button-no-type-id")

Benchee.run(%{
  "fill_in text_field" => fn ->
    fill_in(session, text_field_query, with: "Chris")
  end,
  "visit forms" => fn ->
    visit(session, "forms.html")
  end,
  "find by css #id" => fn ->
    find(session, id_css_query)
  end
},
time: 18,
formatters: [
  &Benchee.Formatters.HTML.output/1,
  &Benchee.Formatters.Console.output/1
],
html: [file: "benchmarks/html/wallaby.html"])

Wallaby.end_session(session)

# Erlang/OTP 19 [erts-8.2] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]
# Elixir 1.4.2
# Benchmark suite executing with the following configuration:
# warmup: 2.0s
# time: 18.0s
# parallel: 1
# inputs: none specified
# Estimated total run time: 60.0s
#
# Benchmarking fill_in text_field...
# Benchmarking find by css #id...
# Benchmarking visit forms...
# Generated benchmarks/html/wallaby.html
#
# Name                         ips        average  deviation         median
# visit forms                 7.91      126.43 ms    ±32.60%      104.05 ms
# find by css #id             5.29      188.87 ms     ±3.34%      188.06 ms
# fill_in text_field          2.53      394.60 ms     ±2.47%      396.18 ms
#
# Comparison:
# visit forms                 7.91
# find by css #id             5.29 - 1.49x slower
# fill_in text_field          2.53 - 3.12x slower
