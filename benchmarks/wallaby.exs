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
