require_relative 'spec_init'

# doesn't respond to anything, only what it records

describe "Record Macro" do
  sink = Telemetry::Controls::Sink::Macro.example

  time = Controls::Time.example

  sink.record_something time, 'some macro data'

  specify do
    sink.recorded_something? { |r| r.data == 'some macro data' }
  end
end
