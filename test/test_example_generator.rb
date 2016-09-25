require 'minitest/autorun'
require 'busy-administrator'

class BusyAdministratorExampleGeneratorTest < Minitest::Test
  def test_generate_string_with_specified_memory_size
    memory_size = BusyAdministrator::MemorySize.new(bytes: 1024 * 1024 * 1)
    string = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(memory_size)

    memsize_of_string = ObjectSpace.memsize_of(string)

    # round to nearest 10 since output is +/- 1
    assert_equal memory_size.bytes.round(-1), memsize_of_string.round(-1)
  end
end