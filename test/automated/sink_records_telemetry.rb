require_relative 'automated_init'

context "Sink Records Telemetry" do
  sink = Telemetry::Controls::Sink.example

  sink.record :something, Time.now, 'some data'
  sink.record :something_else, Time.now, 'some other data'

  test do
    assert(sink.records.length == 2)
  end
end
