require_relative 'automated_init'

context "Sink Lists Records for Specified Signal" do
  sink = Telemetry::Controls::Sink::Macro.example

  time = Telemetry::Controls::Time.example

  sink.record :something, time
  sink.record :something_else, time

  context "With predicate" do
    test do
      records = sink.something_records do |record|
        record.time == time
      end

      assert(records.length == 1)
    end
  end

  context "Without predicate" do
    test do
      assert(sink.something_records.length == 1)
    end
  end
end
