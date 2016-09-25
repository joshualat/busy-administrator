require_relative './examples_helper'
require 'busy-administrator'

class Example
  attr_accessor :large_value
end

def example_1
  results = BusyAdministrator::MemoryUtils.profile(gc_enabled: false) do |analyzer|
    BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)
  end  

  BusyAdministrator::Display.debug(results)
end

def example_2
  testing_a = Example.new
  testing_b = Example.new

  results = BusyAdministrator::MemoryUtils.profile(gc_enabled: false) do |analyzer|
    testing_a.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(4.mebibytes) 
    testing_b.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes) 

    analyzer.include(key: 'testing_a', value: testing_a)
    analyzer.include(key: 'testing_b', value: testing_b)
    analyzer.include(key: 'Example', value: Example)
  end

  BusyAdministrator::Display.debug(results)
end

def main
  run_example "basic example: BusyAdministrator::MemoryUtils.profile(gc_enabled: false)" do
    example_1
  end

  run_example "example with analyzer: BusyAdministrator::MemoryUtils.profile(gc_enabled: false)" do
    example_2
  end
end

main