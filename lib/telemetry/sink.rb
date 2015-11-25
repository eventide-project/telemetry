class Telemetry
  module Sink
    Record = Struct.new :name, :time, :data

    def records
      @records ||= []
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
