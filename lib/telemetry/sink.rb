class Telemetry
  module Sink
    def self.included(cls)
      cls.extend RecordMacro
    end

    module RecordMacro
      def record_macro(name)
        record_method_name = "record_#{name}"
        send(:define_method, record_method_name) do |time, data|
          record name, time, data
        end

        subset_method_name = "recorded_#{name}s"
        send(:define_method, subset_method_name) do |&blk|
          records.select { |r| r.name == name }
        end

        detect_method_name = "recorded_#{name}?"
        send(:define_method, detect_method_name) do |&blk|
          subset = send(subset_method_name)
          subset.any? &blk
        end
      end
      alias :record :record_macro
    end

    Record = Struct.new :name, :time, :data

    def records
      @records ||= []
    end

    def records?(name)
      resond_to? "record_#{name}"
    end

    def recorded?(&blk)
      records.any? &blk
    end

    def record(name, time, data=nil)
      record = Record.new name, time, data
      records << record
    end
  end
end
