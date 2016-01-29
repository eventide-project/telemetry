require_relative 'spec_init'

context "Record Any Telemetry" do
  sink = Telemetry::Controls::Sink::Macro::RecordAny.example

  time = Controls::Time.example

  sink.record :something_else, time

  test do
    recorded = sink.recorded_something? { |r| r.signal == :something_else }
    assert(!recorded)
  end
end
