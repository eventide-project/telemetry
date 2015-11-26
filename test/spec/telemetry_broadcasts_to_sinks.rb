require_relative 'spec_init'

describe "Telemetry Broadcasts" do
  telemetry = Telemetry.new

  sink_1 = Telemetry::Controls::Sink::Macro.example
  sink_2 = Telemetry::Controls::Sink::Macro.example

  telemetry.register sink_1
  telemetry.register sink_2

  telemetry.record :something

  specify "To all its sinks" do
    assert(sink_1.recorded_something?)
    assert(sink_2.recorded_something?)
  end
end
