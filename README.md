Busy Administrator (busy-administrator)
=======================================

Handy Ruby Dev Tools for the Busy Administrator

- check memory usage of block
- check memory usage of current process (rss & vsz)
- check memory size of specific objects (direct & indirect)
- check memory size of hash or array with objects
- check memory size of objects from specific class
- friendly display helper
- friendly memory size wrapper
- example generator to test memory size of objects

## Requirements

Busy Administrator (busy-administrator) requires Ruby(MRI) Version 2.1.0 and above.


## Installation

Busy Administrator (busy-administrator) is available as a RubyGem:

```bash
$ gem install busy-administrator
```

Basic usage (Memory Size)
-------------------------
~~~ ruby
require 'busy-administrator'

data = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

puts BusyAdministrator::MemorySize.of(data)
# => 10 MiB
~~~

Basic usage (Process Utils)
---------------------------
~~~ ruby
require 'busy-administrator'

puts BusyAdministrator::ProcessUtils.get_memory_usage(:rss)
# => 10 MiB
~~~

Basic usage (Memory Utils)
--------------------------

### Code

~~~ ruby
require 'busy-administrator'

results = BusyAdministrator::MemoryUtils.profile(gc_enabled: false) do |analyzer|
  BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)
end  

BusyAdministrator::Display.debug(results)
~~~

### Output

~~~ ruby
{
    memory_usage:
        {
            before: 12 MiB
            after: 22 MiB
            diff: 10 MiB
        }
    total_time: 0.406452
    gc:
        {
            count: 0
            enabled: false
        }
    specific:
        {
        }
    object_count: 151
    general:
        {
            String: 10 MiB
            Hash: 8 KiB
            BusyAdministrator::MemorySize: 0 Bytes
            Process::Status: 0 Bytes
            IO: 432 Bytes
            Array: 326 KiB
            Proc: 72 Bytes
            RubyVM::Env: 96 Bytes
            Time: 176 Bytes
            Enumerator: 80 Bytes
        }
}
~~~

Memory Size of
--------------
~~~ ruby
require 'busy-administrator'

class ExampleA
  attr_accessor :large_value
end

class ExampleB
  attr_accessor :large_value
  attr_accessor :linked_example
end

example = ExampleA.new
example.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

puts BusyAdministrator::MemorySize.of(example)
# => 10 MiB
~~~

Memory Size (Indirect)
----------------------
~~~ ruby
require 'busy-administrator'

class ExampleA
  attr_accessor :large_value
end

class ExampleB
  attr_accessor :large_value
  attr_accessor :linked_example
end

first = ExampleB.new
first.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

second = ExampleB.new
second.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes)

first.linked_example = second

puts BusyAdministrator::MemorySize.of(first)
# => 15 MiB
~~~


Memory Size of all objects from class
-------------------------------------
~~~ ruby
require 'busy-administrator'

class ExampleA
  attr_accessor :large_value
end

class ExampleB
  attr_accessor :large_value
  attr_accessor :linked_example
end

first = ExampleB.new
first.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(10.mebibytes)

second = ExampleB.new
second.large_value = BusyAdministrator::ExampleGenerator.generate_string_with_specified_memory_size(5.mebibytes)

first.linked_example = second
second.linked_example = first

puts BusyAdministrator::MemorySize.of_all_objects_from(ExampleB)
# => 15 MiB
~~~

Memory Utils with Analyzer (memory size of specific objects)
------------------------------------------------------------

### Code

~~~ ruby
require 'busy-administrator'

class ExampleA
  attr_accessor :large_value
end

class ExampleB
  attr_accessor :large_value
  attr_accessor :linked_example
end

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
~~~

### Output

~~~ ruby
{
    memory_usage:
        {
            before: 22 MiB
            after: 26 MiB
            diff: 4 MiB
        }
    total_time: 0.376368
    gc:
        {
            count: 0
            enabled: false
        }
    specific:
        {
            testing_a: 4 MiB
            testing_b: 5 MiB
            Example: 9 MiB
        }
    object_count: 273
    general:
        {
            Hash: 22 KiB
            String: 9 MiB
            BusyAdministrator::MemorySize: 0 Bytes
            Process::Status: 0 Bytes
            IO: 432 Bytes
            Array: 296 KiB
            Time: 176 Bytes
            Enumerator: 160 Bytes
            ObjectSpace::InternalObjectWrapper: 3 KiB
        }
}
~~~

Memory Size Wrapper
-------------------
~~~ ruby
require 'busy-administrator'

puts "1.kibibyte = #{ 1.kibibyte }"
# => 1.kibibyte = 1 KiB

puts 1.kibibyte.class
# => BusyAdministrator::MemorySize

puts "2.mebibytes >= 1.mebibyte : #{ 2.mebibytes >= 1.mebibyte }"
puts "2.mebibytes >= 2.mebibytes: #{ 2.mebibytes >= 2.mebibytes }" 
puts "2.mebibytes >  2.mebibytes: #{ 2.mebibytes > 2.mebibytes }"
puts "2.mebibytes <  3.mebibytes: #{ 2.mebibytes < 3.mebibytes }" 
puts "3.mebibytes <  2.mebibytes: #{ 3.mebibytes < 2.mebibytes }"

# => 2.mebibytes >= 1.mebibyte : true
# => 2.mebibytes >= 2.mebibytes: true
# => 2.mebibytes >  2.mebibytes: false
# => 2.mebibytes <  3.mebibytes: true
# => 3.mebibytes <  2.mebibytes: false

puts "1.mebibyte + 2.mebibytes  : #{ 1.mebibyte + 2.mebibytes } "
puts "3.mebibytes - 2.mebibytes : #{ 3.mebibytes - 2.mebibytes } "
puts "4.mebibytes * 3           : #{ 4.mebibytes * 3 } "
puts "12.mebibytes / 3          : #{ 12.mebibytes / 3 } "

# => 1.mebibyte + 2.mebibytes  : 3 MiB 
# => 3.mebibytes - 2.mebibytes : 1 MiB 
# => 4.mebibytes * 3           : 12 MiB 
# => 12.mebibytes / 3          : 4 MiB
~~~

License
-------
Copyright (c) 2016 Joshua Arvin Lat

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.