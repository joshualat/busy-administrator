module BusyAdministrator
  module MemoryUtils
    class MemoryAnalyzer
      attr_reader :pairs

      def initialize
        @pairs = []
      end

      def include(key:, value:)
        @pairs << [key, value.object_id]
      end

      def analyze(verbose: false)
        output = {}

        @pairs.each do |pair|
          key, value = pair

          target = ObjectSpace._id2ref(value)

          if target.is_a?(Class) || target.is_a?(Module)
            output[key.to_sym] = MemorySize.of_all_objects_from(target)
          else
            output[key.to_sym] = MemorySize.of(target)
          end

          log("#{ key } = #{ output[key.to_sym] } { #{ target.class } }", verbose: verbose)
        end

        output
      end

      private

      def log(message, verbose: false)
        if verbose
          puts "[BusyAdministrator::MemoryUtils::Analyzer.analyze] #{ message }"
        end
      end
    end

    class << self
      def trigger_gc
        GC.start(full_mark:true, immediate_sweep: true, immediate_mark: false)
      end

      def get_created_object_classes
        ObjectSpace.each_object.to_a.map(&:class).uniq.select do |target| 
          target.is_a?(Class) || target.is_a?(Module)
        end
      end

      def profile(gc_enabled: true, verbose: false)
        analyzer = MemoryAnalyzer.new
        excluded_object_id_storage = []
        all_object_ids_after_execution = []
        gc_count_before = 0

        output_container = {
          memory_usage: {},
          total_time: 0.0,
          gc: {
            count: 0,
            enabled: false
          }
        }

        action("GC Settings") do
          output_container[:gc][:enabled] = gc_enabled

          if gc_enabled
            GC.enable
            log("[Before] Enable GC", verbose: verbose)
          else
            GC.disable
            log("[Before] Disable GC", verbose: verbose)
          end
        end

        action("Prepare Object ID Storage Before Execution") do
          excluded_object_id_storage = get_created_object_ids
          log("[Before] Object Count: #{ excluded_object_id_storage.size }", verbose: verbose)          
        end

        action("Get Memory Usage Before Execution") do
          memory_usage_before = ProcessUtils.get_memory_usage(:rss)
          output_container[:memory_usage][:before] = memory_usage_before

          log("[Before] Memory Usage: #{ memory_usage_before }", verbose: verbose)
        end

        action("Execute Main Action") do
          gc_count_before = GC.stat[:count]
          log("[Before] GC Count: #{ gc_count_before }", verbose: verbose)

          log("[Before] Block Start", verbose: verbose)

          total_time = Benchmark.realtime do
            yield(analyzer) if block_given?
          end

          output_container[:total_time] = total_time.round(6)

          log("[After] Block End", verbose: verbose)
          log("[After] Total Time: #{ total_time } seconds", verbose: verbose)
        end

        action("Compute Specific Stats") do
          output_container[:specific] = analyzer.analyze(verbose: verbose)
        end

        action("Run GC if enabled") do 
          if gc_enabled
            self.trigger_gc
            log("[After] Run GC", verbose: verbose)
          end

          gc_count_after = GC.stat[:count]
          log("[After] GC Count: #{ gc_count_after }", verbose: verbose)

          gc_count_diff = gc_count_after - gc_count_before
          output_container[:gc][:count] = gc_count_diff

          log("[Diff] GC Count: #{ gc_count_diff }", verbose: verbose)
        end

        action("Get Memory Usage After Execution") do
          memory_usage_after = ProcessUtils.get_memory_usage(:rss)
          log("[After] Memory Usage: #{ memory_usage_after }", verbose: verbose)

          output_container[:memory_usage][:after] = memory_usage_after
          output_container[:memory_usage][:diff] = output_container[:memory_usage][:after] - output_container[:memory_usage][:before]
          log("[Diff] Memory Usage: #{ output_container[:memory_usage] }", verbose: verbose)
        end
        
        action("Get Object Count After Execution") do
          all_object_ids_after_execution = get_created_object_ids
          log("[After] Object Count: #{ all_object_ids_after_execution.size }", verbose: verbose)

          all_object_ids_after_execution -= excluded_object_id_storage
          log("[Diff] Object Count: #{ all_object_ids_after_execution.size }", verbose: verbose)
          output_container[:object_count] = all_object_ids_after_execution.size
        end

        action("Compute General Stats") do
          general = {}

          all_object_ids_after_execution.each do |object_id|
            target = ObjectSpace._id2ref(object_id) rescue nil

            if target_class = target.class.name rescue nil
              general[target_class.to_sym] ||= 0
              general[target_class.to_sym] += ObjectSpace.memsize_of(target)
            end
          end

          general.each do |key, value|
            general[key] = MemorySize.new(bytes: value)
            log("[Diff] Class #{ key }: #{ general[key] } ")
          end

          output_container[:general] = general
        end

        action("Run GC") do
          GC.enable
          self.trigger_gc
        end
        
        output_container
      end

      private

      def action(label)
        log("Action: #{ label }")

        yield if block_given?
      end

      def log(message, verbose: false)
        if verbose
          puts "[BusyAdministrator::MemoryUtils.profile] #{ message }"
        end
      end

      def get_created_object_ids
        output = ObjectSpace.each_object.to_a.map(&:object_id)
        output << output.object_id

        output
      end

      def get_unique_classes_from_object_ids(object_ids_array)
        object_ids_array.map { |object_id| ObjectSpace._id2ref(object_id) }.map(&:class).uniq.select do |target|
          target.is_a?(Class) || target.is_a?(Module)
        end
      end
    end
  end
end