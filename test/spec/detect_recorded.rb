require_relative 'spec_init'

describe "Detect Recorded Telemetry" do
  sink = Telemetry::Controls::Sink.example

  sink.record :something, Time.now, 'some data'

  specify "With predicate" do
    assert(sink.recorded? { |r| r.signal == :something })
  end

  specify "Without predicate" do
    assert(sink.recorded?)
  end
end
