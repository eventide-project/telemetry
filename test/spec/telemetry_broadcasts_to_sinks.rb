require_relative 'spec_init'

describe "Detect Recorded Telemetry" do
  telemetry = Telemetry.new
  sink = Telemetry::Controls::Sink.example

  telemetry.register sink

  telemetry.record :something, 'some data'

  specify "With predicate" do
    assert(sink.recorded? { |r| r.name == :something })
  end

  specify "Without predicate" do
    assert(sink.recorded?)
  end
end
