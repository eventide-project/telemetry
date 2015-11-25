require_relative 'spec_init'

describe "Record Macro" do
  sink = Telemetry::Controls::Sink::Macro.example

  time = Controls::Time.example

  sink.record_something time, 'some macro data'

  specify do
    sink.recorded_something? { |r| r.data == 'some macro data' }
  end
end
