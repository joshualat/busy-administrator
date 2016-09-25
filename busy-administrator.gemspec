# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'busy-administrator/version'

included_files = [
  'display',
  'example_generator',
  'memory_size',
  'memory_utils',
  'process_utils',
  'version'
].map { |filename| "lib/busy-administrator/#{ filename }.rb" }

included_files << 'lib/busy-administrator.rb'

Gem::Specification.new do |spec|
  spec.name          = 'busy-administrator'
  spec.version       = BusyAdministrator::VERSION
  spec.authors       = ['Joshua Arvin Lat']
  spec.email         = ['joshua.arvin.lat@gmail.com']
  spec.summary       = %q{Handy Ruby Dev Tools for the Busy Administrator}
  spec.description   = %q{Handy Ruby Dev Tools for the Busy Administrator}
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.files         = included_files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', "~> 1.5"
  spec.add_development_dependency 'rake'
end