require 'objspace'
require 'benchmark'
require 'busy-administrator/display'
require 'busy-administrator/example_generator'
require 'busy-administrator/memory_size'
require 'busy-administrator/memory_utils'
require 'busy-administrator/process_utils'
require 'busy-administrator/version'

"""
require 'busy-administrator'

BusyAdministrator::MemoryUtils.get_created_object_classes
BusyAdministrator::MemoryUtils.profile(verbose: true) do
  puts 'something'
end

class Testing
  attr_accessor :large_value
end

BusyAdministrator::MemoryUtils.profile(verbose: true, gc_enabled: false) do |analyzer|
  data = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

  testing_a = Testing.new
  testing_a.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes) 

  testing_b = Testing.new
  testing_b.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes) 

  analyzer.include(key: 'data', value: data)
  analyzer.include(key: 'testing_a', value: testing_a)
  analyzer.include(key: 'testing_b', value: testing_b)
  analyzer.include(key: 'Testing', value: Testing)
end

data = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)
BusyAdministrator::MemorySize.of(data).mebibytes
BusyAdministrator::MemorySize.of_all_objects_from(SampleClass).mebibytes

BusyAdministrator::ProcessUtils.get_memory_usage(:rss).mebibytes
BusyAdministrator::ProcessUtils.get_memory_usage(:vsz).mebibytes

# set max memory usage will check vsz
BusyAdministrator::ProcessUtils.set_max_memory_usage(100.mebibytes)
BusyAdministrator::ProcessUtils.get_max_memory_usage.mebibytes

TODO:
Create gem and add tests and documentation
Add option to set recursion level for MemorySize
Add advanced analyzer for objects with references to other objects
"""

module BusyAdministrator
end