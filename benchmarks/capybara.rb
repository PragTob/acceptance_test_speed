require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'benchmark/ips'

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
