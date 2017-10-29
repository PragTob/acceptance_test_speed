# make sure to `mix run --no-halt server_start.exs` before so it has a server
# to run against.

require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'benchmark/ips'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs: "/home/tobi/github/acceptance_test_speed/node_modules/.bin/phantomjs")
end

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.app_host = "http://localhost:8765"

class Tester
  include Capybara::DSL

  def setup
    visit "/"
    visit "/forms.html"
  end

  def fill_in_field
    page.fill_in("name", with: "Chris")
  end

  def visit_forms
    visit "/forms.html"
  end

  def find_id
    find("#button-no-type-id")
  end
end

tester = Tester.new

tester.setup

Benchmark.ips do |bm|
  bm.time = 18
  bm.warmup = 2

  bm.report "fill_in text field" do
    tester.fill_in_field
  end

  bm.report "visit forms" do
    tester.visit_forms
  end

  bm.report "find by css id" do
    tester.find_id
  end

  bm.compare!
end

# Warming up --------------------------------------
#   fill_in text field    23.000  i/100ms
#          visit forms     1.000  i/100ms
#       find by css id    94.000  i/100ms
# Calculating -------------------------------------
#   fill_in text field    239.736  (± 8.8%) i/s -      4.301k in  18.085690s
#          visit forms      9.622  (± 0.0%) i/s -    174.000  in  18.086288s
#       find by css id    981.868  (±14.4%) i/s -     17.296k in  18.065214s
#
# Comparison:
#       find by css id:      981.9 i/s
#   fill_in text field:      239.7 i/s - 4.10x  slower
#          visit forms:        9.6 i/s - 102.04x  slower
