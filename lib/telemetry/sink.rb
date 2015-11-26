class Telemetry
  module Sink
    def record_any?
      false
    end

    def self.included(cls)
      cls.extend RecordMacro
      cls.extend RecordAnyMacro
    end

    module RecordMacro
      def record_macro(name)
        record_method_name = "record_#{name}"
        send(:define_method, record_method_name) do |time, data|
          record name, time, data
        end

        subset_method_name = "#{name}_records"
        send(:define_method, subset_method_name) do |&blk|
          records.select { |r| r.name == name }
        end

        detect_method_name = "recorded_#{name}?"
        send(:define_method, detect_method_name) do |&blk|
          subset = send(subset_method_name)

          if blk.nil?
            return !subset.empty?
          else
            return subset.any? &blk
          end
        end
      end
      alias :record :record_macro
    end

    module RecordAnyMacro
      def record_any_macro
        send(:define_method, :record_any?) do
          true
        end
      end
      alias :record_any :record_any_macro
    end

    Record = Struct.new :name, :time, :data

    def records
      @records ||= []
    end

    def records?(name)
      respond_to? "record_#{name}"
    end

    def record?(name)
      record = false
      if record_any?
        record = true
      else
        if records? name
          record = true
        end
      end
      record
    end

    def recorded?(&blk)
      if blk.nil?
        return !records.empty?
      else
        return records.any? &blk
      end
    end

    def record(name, time, data=nil, force: nil)
      force ||= false

      record = nil
      if force || record?(name)
        record = Record.new name, time, data
        records << record
      end
      record
    end
  end
end
