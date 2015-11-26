require_relative 'spec_init'

describe "Sink Lists Records for Specified Name" do
  sink = Telemetry::Controls::Sink::Macro.example

  time = Controls::Time.example

  sink.record :something, time
  sink.record :something_else, time

  specify do
    assert(sink.something_records.length == 1)
  end
end
