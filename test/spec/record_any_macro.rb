require_relative 'spec_init'

describe "Record Any Macro" do
  sink = Telemetry::Controls::Sink::Macro::RecordAny.example

  specify "Creates record_any? predicate that always returns true" do
    assert(sink.record_any?)
  end
end
