require 'minitest/autorun'
require 'busy-administrator'

class BusyAdministratorMemorySizeTest < Minitest::Test
  def test_numeric_memory_size_kibibytes
    assert_equal 1.kibibyte, BusyAdministrator::MemorySize.new(bytes: 1024)
  end

  def test_numeric_memory_size_kilobytes
    assert_equal 1.kilobyte, BusyAdministrator::MemorySize.new(bytes: 1000)
  end

  def test_numeric_memory_size_mebibytes
    assert_equal 1.mebibyte, BusyAdministrator::MemorySize.new(bytes: 1024 * 1024)
  end

  def test_numeric_memory_size_megabytes
    assert_equal 1.megabyte, BusyAdministrator::MemorySize.new(bytes: 1000 * 1000)
  end

  def test_memory_size_bytes
    assert_equal BusyAdministrator::MemorySize.new(bytes: 1024).bytes, 1024
  end

  def test_memory_size_kibibytes
    assert_equal BusyAdministrator::MemorySize.new(bytes: 1024).kibibytes, 1
  end

  def test_memory_size_kilobytes
    assert_equal BusyAdministrator::MemorySize.new(bytes: 1000).kilobytes, 1
  end

  def test_memory_size_mebibytes
    assert_equal BusyAdministrator::MemorySize.new(bytes: 1024 * 1024).mebibytes, 1
  end

  def test_memory_size_megabytes
    assert_equal BusyAdministrator::MemorySize.new(bytes: 1000 * 1000).megabytes, 1
  end

  def test_memory_size_addition
    assert_equal 1.mebibyte + 2.mebibytes, 3.mebibytes
  end

  def test_memory_size_subtraction
    assert_equal 3.mebibytes - 2.mebibytes, 1.mebibyte
  end

  def test_memory_size_multiplication
    assert_equal 4.mebibytes * 3, 12.mebibytes
  end

  def test_memory_size_division
    assert_equal 12.mebibytes / 3, 4.mebibytes
  end

  def test_memory_size_equality
    assert_equal 1.mebibyte, 1.mebibyte
  end

  def test_memory_size_greater_than
    assert 2.mebibytes > 1.mebibyte
  end

  def test_memory_size_greater_than_equal
    assert 2.mebibytes >= 1.mebibyte
    assert 2.mebibytes >= 2.mebibytes
  end

  def test_memory_size_less_than
    assert 1.mebibyte < 2.mebibytes
  end

  def test_memory_size_less_than_equal
    assert 1.mebibyte <= 2.mebibytes
    assert 2.mebibytes <= 2.mebibytes
  end

  def test_memory_size_class_kilobytes
    assert_equal BusyAdministrator::MemorySize.kilobytes(1), 1.kilobyte
  end

  def test_memory_size_class_kibibytes
    assert_equal BusyAdministrator::MemorySize.kibibytes(1), 1.kibibyte
  end

  def test_memory_size_class_megabytes
    assert_equal BusyAdministrator::MemorySize.megabytes(1), 1.megabyte
  end

  def test_memory_size_class_megabytes
    assert_equal BusyAdministrator::MemorySize.megabytes(1), 1.megabyte
  end

  def test_memory_size_class_mebibytes
    assert_equal BusyAdministrator::MemorySize.mebibytes(1), 1.mebibyte
  end
end