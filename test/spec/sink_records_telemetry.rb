require_relative 'spec_init'

describe "Sink Records Telemetry" do
  sink = Telemetry::Controls::Sink.example

  sink.record :something, Time.now, 'some data'
  sink.record :something_else, Time.now, 'some other data'

  specify do
    assert(sink.records.length == 2)
  end
end
