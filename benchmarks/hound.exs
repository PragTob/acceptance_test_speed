# ATTENTION: gotta start phantomjs via `phantomjs --wd` first..
Application.ensure_all_started(:hound)
{:ok, server} = SimpleServer.start

Application.put_env(:hound, :app_host, "http://localhost")
Application.put_env(:hound, :app_port, SimpleServer.port(server))


use Hound.Helpers

# Hound seems to identify sessions via PID and there is no way to pass in the
# session or whatever... so that's another use case for benchees before/after
# to prepare a session for the benchmark (benchs run in their own processes)
Benchee.run(%{
  "fill_in text_field" => fn ->
    fill_field({:name, "user[name]"}, "Chris")
  end,
  "visit forms" => fn ->
    navigate_to("#{server.base_url}/forms.html")
  end,
  "find by css #id" => fn ->
    find_element(:id, "button-no-type-id")
  end
},
time: 18,
formatters: [
  Benchee.Formatters.HTML,
  Benchee.Formatters.Console
],
html: [file: "benchmarks/html/hound.html"],
before_scenario: fn(input) ->
  Hound.start_session()
  navigate_to("#{server.base_url}/forms.html")
  input
end,
after_scenario: fn(_return) ->
  Hound.end_session
end)
