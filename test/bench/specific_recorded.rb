require_relative './bench_init'

context "Sink Lists Records for Specified signal" do
  sink = Telemetry::Controls::Sink::Macro.example

  time = Telemetry::Controls::Time.example

  sink.record :something, time
  sink.record :something_else, time

  test do
    assert(sink.something_records.length == 1)
  end
end
