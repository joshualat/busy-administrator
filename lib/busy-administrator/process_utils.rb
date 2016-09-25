module BusyAdministrator
  module ProcessUtils
    class << self
      # http://stackoverflow.com/questions/7880784/what-is-rss-and-vsz-in-linux-memory-management
      def get_memory_usage(metric = :rss)
        available_options = [:rss, :vsz]

        if available_options.include?(metric)
          bytes = `ps -o #{ metric.to_s }= -p #{ Process.pid }`.to_i * 1024

          MemorySize.new(bytes: bytes)
        else
          raise Exception, "available_options: #{ available_options.inspect }"
        end
      end

      # Does not work in OSX
      # Will raise NoMemoryError: failed to allocate memory
      def set_max_memory_usage(mebibytes:)
        Process.setrlimit(Process::RLIMIT_AS, mebibytes * 1024 * 1024)
      end

      def get_max_memory_usage
        bytes = Process.getrlimit(Process::RLIMIT_AS)[1]

        MemorySize.new(bytes: bytes)
      end
    end
  end
end