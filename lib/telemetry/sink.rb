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
      def record_macro(signal)
        record_method_name = "record_#{signal}"
        send(:define_method, record_method_name) do |time, data|
          record signal, time, data
        end

        subset_method_name = "#{signal}_records"
        send(:define_method, subset_method_name) do |&blk|
          subset = records.select { |r| r.signal == signal }

          unless blk.nil?
            subset = subset.select(&blk)
          end

          subset
        end

        detect_method_name = "recorded_#{signal}?"
        send(:define_method, detect_method_name) do |&blk|
          subset = send(subset_method_name)

          if blk.nil?
            return !subset.empty?
          else
            return subset.any?(&blk)
          end
        end

        detect_once_method_name = "recorded_#{signal}_once?"
        send(:define_method, detect_once_method_name) do |&blk|
          subset = send(subset_method_name)

          if blk.nil?
            return subset.count == 1
          else
            return subset.one?(&blk)
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

    Record = Struct.new :signal, :time, :data

    Error = Class.new(RuntimeError)

    def records
      @records ||= []
    end

    def records?(signal)
      respond_to? "record_#{signal}"
    end

    def record?(signal)
      record = false
      if record_any?
        record = true
      else
        if records? signal
          record = true
        end
      end
      record
    end

    def record(signal, time, data=nil, force: nil)
      force ||= false

      record = nil
      if force || record?(signal)
        record = Record.new signal, time, data
        records << record
      end
      record
    end

    def recorded?(&blk)
      if blk.nil?
        return !records.empty?
      else
        return records.any?(&blk)
      end
    end

    def recorded_once?(&blk)
      if blk.nil?
        return records.count == 1
      else
        return records.one?(&blk)
      end
    end

    def one_record(&blk)
      records = self.records

      unless blk.nil?
        records = records.select(&blk)
      end

      case records.count
      when 0
        return nil
      when 1
        return records[0]
      else
        raise Error, "More than one matching record was recorded"
      end
    end
  end
end
