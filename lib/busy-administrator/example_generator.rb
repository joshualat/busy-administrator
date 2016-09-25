require 'securerandom'

module BusyAdministrator
  module ExampleGenerator
    class << self
      def generate_string_with_specified_memory_size(memory_size)
        raise Exception unless memory_size.respond_to?(:mebibytes)

        SecureRandom.random_bytes(memory_size.bytes)
      end
    end
  end
end