require_relative './examples_helper'
require 'busy-administrator'

class ExampleA
  attr_accessor :large_value
end

class ExampleB
  attr_accessor :large_value
  attr_accessor :linked_example
end

def main
  run_example "direct" do
    data = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

    actual = BusyAdministrator::MemorySize.of(data)
    puts "BusyAdministrator::MemorySize.of(data) = #{ actual }"
  end

  run_example "indirect" do
    example = ExampleA.new
    example.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

    actual = BusyAdministrator::MemorySize.of(example)
    puts "BusyAdministrator::MemorySize.of(example) = #{ actual }"
  end

  run_example "memory size of all objects from class" do
    first = ExampleB.new
    first.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

    second = ExampleB.new
    second.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes)

    first.linked_example = second
    second.linked_example = first

    actual = BusyAdministrator::MemorySize.of_all_objects_from(ExampleB)
    puts "BusyAdministrator::MemorySize.of_all_objects_from(ExampleB) = #{ actual }"
  end
end

main