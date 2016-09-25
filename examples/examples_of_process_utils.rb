require_relative './examples_helper'
require 'busy-administrator'

def main
  run_example "BusyAdministrator::ProcessUtils.get_memory_usage(:rss)" do
    puts "rss = #{ BusyAdministrator::ProcessUtils.get_memory_usage(:rss) }"
  end

  run_example "BusyAdministrator::ProcessUtils.get_memory_usage(:vsz)" do
    puts "vsz = #{ BusyAdministrator::ProcessUtils.get_memory_usage(:vsz) }"
  end
end

main