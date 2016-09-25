require 'minitest/autorun'
require 'busy-administrator'

class ExampleA
  attr_accessor :large_value
end

class ExampleB
  attr_accessor :large_value
  attr_accessor :linked_example
end

class BusyAdministratorMemorySizeTest < Minitest::Test
  def setup
    GC.start
    GC.disable
  end

  def teardown
    GC.enable
    GC.start
  end

  def test_memory_size_of_direct
    data = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

    actual = BusyAdministrator::MemorySize.of(data).bytes
    expected = 10.mebibytes.bytes

    # round to nearest 10 since output is +/- 1
    assert_equal expected.round(-1), actual.round(-1)
  end

  def test_memory_size_of_indirect
    example = ExampleA.new
    example.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

    actual = BusyAdministrator::MemorySize.of(example).bytes
    expected = 10.mebibytes.bytes

    # round to nearest 10 since output is +/- 1
    assert_equal expected.round(-1), actual.round(-1)
  end

  def test_memory_size_of_indirect_deep
    first = ExampleB.new
    first.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(3.mebibytes)

    second = ExampleB.new
    second.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes)

    third = ExampleA.new
    third.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(17.mebibytes)

    first.linked_example = second
    second.linked_example = third

    actual = BusyAdministrator::MemorySize.of(first).bytes
    expected = 25.mebibytes.bytes

    # round to nearest 10 since output is +/- 1
    assert_equal expected.round(-1), actual.round(-1)
  end

  def test_memory_size_of_all_objects_from_class_simple
    first = ExampleA.new
    first.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

    second = ExampleA.new
    second.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes)

    actual = BusyAdministrator::MemorySize.of_all_objects_from(ExampleA).bytes
    expected = 15.mebibytes.bytes

    # round to nearest 10 since output is +/- 1
    assert_equal expected.round(-1), actual.round(-1)
  end

  def test_memory_size_of_all_objects_from_class_prevent_double_count
    first = ExampleB.new
    first.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

    second = ExampleB.new
    second.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes)

    first.linked_example = second
    second.linked_example = first

    actual = BusyAdministrator::MemorySize.of_all_objects_from(ExampleB).bytes
    expected = 15.mebibytes.bytes

    # round to nearest 10 since output is +/- 1
    assert_equal expected.round(-1), actual.round(-1)
  end
end