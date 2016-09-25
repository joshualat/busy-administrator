require 'minitest/autorun'
require 'busy-administrator'

class BusyAdministratorProcessUtilsTest < Minitest::Test
  def test_get_memory_usage_rss
    bytes = `ps -o rss= -p #{ Process.pid }`.to_i * 1024

    assert_equal BusyAdministrator::ProcessUtils.get_memory_usage(:rss).mebibytes, BusyAdministrator::MemorySize.new(bytes: bytes).mebibytes
  end

  def test_get_memory_usage_vsz
    bytes = `ps -o vsz= -p #{ Process.pid }`.to_i * 1024

    assert_equal BusyAdministrator::ProcessUtils.get_memory_usage(:vsz).mebibytes, BusyAdministrator::MemorySize.new(bytes: bytes).mebibytes
  end
end