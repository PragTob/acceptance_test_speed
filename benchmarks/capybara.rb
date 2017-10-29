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

# tobi@speedy ~/github/acceptance_test_speed $ ruby benchmarks/capybara.rb 
# Warming up --------------------------------------
#   fill_in text field    31.000  i/100ms
#          visit forms     1.000  i/100ms
#       find by css id   126.000  i/100ms
# Calculating -------------------------------------
#   fill_in text field    314.732  (± 5.4%) i/s -      5.673k in  18.076096s
#          visit forms      9.819  (± 0.0%) i/s -    177.000  in  18.029034s
#       find by css id      1.265k (± 5.4%) i/s -     22.806k in  18.086122s
#
# Comparison:
#       find by css id:     1264.7 i/s
#   fill_in text field:      314.7 i/s - 4.02x  slower
#          visit forms:        9.8 i/s - 128.81x  slower
