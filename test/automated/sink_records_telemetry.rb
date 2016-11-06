require_relative 'automated_init'

context "Sink Records Telemetry" do
  sink = Telemetry::Controls::Sink.example

  sink.record :something, 'some_time', 'some data'
  sink.record :something_else, 'some_time', 'some other data'

  test do
    assert(sink.records.length == 2)
  end
end
