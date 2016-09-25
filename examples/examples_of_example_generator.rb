require_relative './examples_helper'
require 'busy-administrator'

def main
  run_example "BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(2.mebibytes)" do
    example = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(2.mebibytes)
    size = BusyAdministrator::MemorySize.of(example)
    puts "BusyAdministrator::MemorySize.of(example) = #{ size }"
  end
end

main