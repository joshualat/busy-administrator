class Numeric
  [:mebibytes, :megabytes, :kibibytes, :kilobytes].each do |method|
    define_method(method) do
      BusyAdministrator::MemorySize.send(method, self)
    end
  end

  alias_method :mebibyte, :mebibytes
  alias_method :megabyte, :megabytes
  alias_method :kibibyte, :kibibytes
  alias_method :kilobyte, :kilobytes
end

module BusyAdministrator
  class MemorySize
    def initialize(bytes:)
      @bytes = bytes
    end

    def bytes
      @bytes
    end

    def kibibytes
      @bytes / 1024
    end

    def kilobytes
      @bytes / 1000
    end

    def mebibytes
      @bytes / 1024 / 1024
    end

    def megabytes
      @bytes / 1000 / 1000
    end

    def +(other)
      self.class.new(bytes: @bytes + other.bytes)
    end

    def -(other)
      self.class.new(bytes: @bytes - other.bytes)
    end

    def *(number)
      self.class.new(bytes: @bytes * number)
    end

    def /(number)
      self.class.new(bytes: @bytes / number)
    end

    def ==(other_object)
      self.bytes == other_object.bytes
    end

    def >(other_object)
      self.bytes > other_object.bytes
    end

    def >=(other_object)
      self.bytes >= other_object.bytes
    end

    def <(other_object)
      self.bytes < other_object.bytes
    end

    def <=(other_object)
      self.bytes <= other_object.bytes
    end

    def to_s
      if @bytes < 1024
        "#{ bytes } Bytes"
      elsif @bytes < 1024 * 1024
        "#{ kibibytes } KiB"
      else
        "#{ mebibytes } MiB"
      end
    end

    def inspect
      to_s
    end

    class << self
      def kibibytes(num)
        new(bytes: num * 1024)
      end

      def kilobytes(num)
        new(bytes: num * 1000)
      end

      def mebibytes(num)
        new(bytes: num * 1024 * 1024)
      end

      def megabytes(num)
        new(bytes: num * 1000 * 1000)
      end

      def of(target, checked_objects: [])
        total_size = 0

        unless checked_objects.include?(target.object_id)
          total_size += ObjectSpace.memsize_of(target)

          checked_objects << target.object_id

          (ObjectSpace.reachable_objects_from(target) || []).each do |reachable_object|
            return new(bytes: 0) if reachable_object.is_a?(ObjectSpace::InternalObjectWrapper)

            total_size += self.of(reachable_object, checked_objects: checked_objects).bytes
          end        
        end

        new(bytes: total_size)
      end

      def of_all_objects_from(target)
        total_memory_size = 0

        # ensure that we don't double count duplicates
        checked_objects = []

        if target.is_a?(Class) || target.is_a?(Module)
          ObjectSpace.each_object(target).each do |instance|
            total_memory_size += self.of(instance, checked_objects: checked_objects).bytes
          end
        else
          raise Exception, "target should be a Class or Module"
        end

        new(bytes: total_memory_size)
      end
    end
  end
end