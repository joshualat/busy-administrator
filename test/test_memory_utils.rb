require 'minitest/autorun'
require 'busy-administrator'

class Example
  attr_accessor :large_value
end

class BusyAdministratorMemoryUtilsTest < Minitest::Test
  def setup
    GC.start
    GC.disable
  end

  def teardown
    GC.enable
    GC.start
  end

  def test_trigger_gc
    assert BusyAdministrator::MemoryUtils.respond_to?(:trigger_gc)
  end

  def test_getcreated_object_classes
    BusyAdministrator::MemoryUtils.get_created_object_classes.each do |created_class|
      assert created_class.is_a?(Class) || created_class.is_a?(Module)
    end
  end

  def test_profile_array_of_strings
    data = []

    results = BusyAdministrator::MemoryUtils.profile(gc_enabled: false) do |analyzer|
      10.times do |i|
        data[i] = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(1.mebibytes)
      end

      analyzer.include(key: 'data', value: data)
    end

    assert 10.mebibytes.mebibytes >= results[:memory_usage][:diff].mebibytes
    assert 10.mebibytes.mebibytes == results[:specific][:data].mebibytes
  end

  def test_profile_objects
    testing_a = Example.new
    testing_b = Example.new

    results = BusyAdministrator::MemoryUtils.profile(gc_enabled: false) do |analyzer|
      testing_a.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(4.mebibytes) 
      testing_b.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes) 

      analyzer.include(key: 'testing_a', value: testing_a)
      analyzer.include(key: 'testing_b', value: testing_b)
      analyzer.include(key: 'Example', value: Example)
    end

    assert 9.mebibytes.mebibytes >= results[:memory_usage][:diff].mebibytes
    assert 4.mebibytes.mebibytes == results[:specific][:testing_a].mebibytes
    assert 5.mebibytes.mebibytes == results[:specific][:testing_b].mebibytes
    assert 9.mebibytes.mebibytes == results[:specific][:Example].mebibytes
  end
end