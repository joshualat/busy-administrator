require_relative './examples_helper'
require 'busy-administrator'

def main
  run_example "1.kibibyte" do
    puts "1.kibibyte = #{ 1.kibibyte }"
  end

  run_example "2.kibibytes" do
    puts "2.kibibytes = #{ 2.kibibytes }"
  end

  run_example "BusyAdministrator::MemorySize.new(bytes: 1000)" do
    puts "BusyAdministrator::MemorySize.new(bytes: 1000) = #{ BusyAdministrator::MemorySize.new(bytes: 1000) }"
    puts "BusyAdministrator::MemorySize.new(bytes: 1000).bytes = #{ BusyAdministrator::MemorySize.new(bytes: 1000).bytes }"
    puts "BusyAdministrator::MemorySize.new(bytes: 1000).kilobytes = #{ BusyAdministrator::MemorySize.new(bytes: 1000).kilobytes }"
  end

  run_example "Comparison" do
    puts "2.mebibytes >= 1.mebibyte : #{ 2.mebibytes >= 1.mebibyte }"
    puts "2.mebibytes >= 2.mebibytes: #{ 2.mebibytes >= 2.mebibytes }" 
    puts "2.mebibytes >  2.mebibytes: #{ 2.mebibytes > 2.mebibytes }"
    puts "2.mebibytes <  3.mebibytes: #{ 2.mebibytes < 3.mebibytes }" 
    puts "3.mebibytes <  2.mebibytes: #{ 3.mebibytes < 2.mebibytes }" 
  end

  run_example "+, -, *, /" do
    puts "1.mebibyte + 2.mebibytes  : #{ 1.mebibyte + 2.mebibytes } "
    puts "3.mebibytes - 2.mebibytes : #{ 3.mebibytes - 2.mebibytes } "
    puts "4.mebibytes * 3           : #{ 4.mebibytes * 3 } "
    puts "12.mebibytes / 3          : #{ 12.mebibytes / 3 } "
  end
end

main