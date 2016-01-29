require_relative 'spec_init'

context "Sink Lists Records for Specified signal" do
  sink = Telemetry::Controls::Sink::Macro.example

  time = Controls::Time.example

  sink.record :something, time
  sink.record :something_else, time

  test do
    assert(sink.something_records.length == 1)
  end
end
