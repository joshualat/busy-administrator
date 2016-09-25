lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

def run_example(label, &block)
  puts ""
  puts "-" * 100
  puts "#{ label }"
  puts "-" * 100
  puts ""

  block.call

  puts ""
  puts ""
end