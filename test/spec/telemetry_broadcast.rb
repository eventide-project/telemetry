require_relative 'spec_init'

describe "Telemetry" do
  telemetry = Telemetry.new

  sink_1 = Telemetry::Controls::Sink::Macro.example

  telemetry.register sink_1

  specify "Broadcasts to its sinks that record the signal" do
    sink_2 = Telemetry::Controls::Sink::Macro.example
    telemetry.register sink_2

    telemetry.record :something

    assert(sink_1.recorded_something?)
    assert(sink_2.recorded_something?)
  end

  specify "Doesn't broadcast to sinks that don't record the signal" do
    sink_2 = Telemetry::Controls::Sink::RecordsOther.example
    telemetry.register sink_2

    telemetry.record :something

    assert(sink_1.recorded_something?)
    refute(sink_2.recorded?)
  end
end
