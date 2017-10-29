# ATTENTION: gotta start phantomjs via `phantomjs --wd` first for hound
{:ok, server} = SimpleServer.start

# Hound setup
Application.ensure_all_started(:hound)
Application.put_env(:hound, :app_host, "http://localhost")
Application.put_env(:hound, :app_port, SimpleServer.port(server))
use Hound.Helpers

# wallaby setup
Application.put_env(:wallaby, :base_url, server.base_url)
use Wallaby.DSL

{:ok, session} = Wallaby.start_session
session = visit(session, "forms.html")
text_field_query = Query.text_field("name")
id_css_query = Query.css("#button-no-type-id")


inputs = %{
  "filling a form field" => :fill,
  "visit url"            => :visit,
  "find css by id"       => :find
}

Benchee.run(%{
  "hound" => {
    fn(input) ->
      case input do
        :fill  -> fill_field({:name, "user[name]"}, "Chris")
        :visit -> navigate_to("#{server.base_url}/forms.html")
        :find ->  find_element(:id, "button-no-type-id")
      end
    end,
    before_scenario: fn(input) ->
      Hound.start_session()
      navigate_to("#{server.base_url}/forms.html")
      input
    end,
    after_scenario: fn(_return) ->
      Hound.end_session
    end
  },
  "wallaby" => fn(input) ->
    case input do
      :fill  -> fill_in(session, text_field_query, with: "Chris")
      :visit -> visit(session, "forms.html")
      :find ->  find(session, id_css_query)
    end
  end
},
  time: 18,
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ],
  html: [file: "benchmarks/html/elixir.html"],
  inputs: inputs
)

Wallaby.end_session(session)

# tobi@speedy ~/github/acceptance_test_speed $ mix run benchmarks/elixir.exs 
# Compiling 1 file (.ex)
# warning: String.to_char_list/1 is deprecated, use String.to_charlist/1
#   lib/simple_server.ex:6
#
# warning: String.to_char_list/1 is deprecated, use String.to_charlist/1
#   lib/simple_server.ex:7
#
# Generated acceptance_test_speed app
# Operating System: Linux
# CPU Information: Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
# Number of Available Cores: 8
# Available memory: 15.61 GB
# Elixir 1.5.2
# Erlang 20.0
# Benchmark suite executing with the following configuration:
# warmup: 2 s
# time: 18 s
# parallel: 1
# inputs: filling a form field, find css by id, visit url
# Estimated total run time: 6 min
#
#
# Benchmarking hound with input filling a form field...
# Benchmarking hound with input find css by id...
# Benchmarking hound with input visit url...
# Benchmarking wallaby with input filling a form field...
# Benchmarking wallaby with input find css by id...
# Benchmarking wallaby with input visit url...
# Generated benchmarks/html/elixir.html
# Generated benchmarks/html/elixir_filling_a_form_field_comparison.html
# Generated benchmarks/html/elixir_filling_a_form_field_hound.html
# Generated benchmarks/html/elixir_filling_a_form_field_wallaby.html
# Generated benchmarks/html/elixir_find_css_by_id_comparison.html
# Generated benchmarks/html/elixir_find_css_by_id_hound.html
# Generated benchmarks/html/elixir_find_css_by_id_wallaby.html
# Generated benchmarks/html/elixir_visit_url_comparison.html
# Generated benchmarks/html/elixir_visit_url_hound.html
# Generated benchmarks/html/elixir_visit_url_wallaby.html
# Opened report using xdg-open
#
# ##### With input filling a form field #####
# Name              ips        average  deviation         median         99th %
# hound            7.28      137.30 ms     ±1.62%      136.02 ms      144.03 ms
# wallaby          2.79      358.74 ms     ±1.13%      356.10 ms      376.06 ms
#
# Comparison:
# hound            7.28
# wallaby          2.79 - 2.61x slower
#
# ##### With input find css by id #####
# Name              ips        average  deviation         median         99th %
# hound           22.63       44.18 ms     ±1.95%       44.00 ms       48.01 ms
# wallaby          5.66      176.66 ms     ±1.04%      176.00 ms      187.55 ms
#
# Comparison:
# hound           22.63
# wallaby          5.66 - 4.00x slower
#
# ##### With input visit url #####
# Name              ips        average  deviation         median         99th %
# hound           19.02       52.59 ms     ±2.69%       52.01 ms       56.06 ms
# wallaby         10.35       96.66 ms     ±1.65%       96.00 ms      103.97 ms
#
# Comparison:
# hound           19.02
# wallaby         10.35 - 1.84x slower
