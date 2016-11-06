require_relative 'automated_init'

context "Record Any Macro" do
  sink = Telemetry::Controls::Sink::Macro::RecordAny.example

  test "Creates record_any? predicate that always returns true" do
    assert(sink.record_any?)
  end
end
