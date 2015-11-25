require_relative 'spec_init'

describe "Record Any Telemetry" do
  sink = Telemetry::Controls::Sink::Macro::RecordAny.example

  time = Controls::Time.example

  sink.record :something_else, time

  specify do
    recorded = sink.recorded_something? { |r| r.name == :something_else }
    refute(recorded)
  end
end
