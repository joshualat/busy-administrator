require 'minitest/autorun'
require 'busy-administrator'

class BusyAdministratorDisplayTest < Minitest::Test
  def test_display_debug
    assert BusyAdministrator::Display.respond_to?(:debug)
  end
end