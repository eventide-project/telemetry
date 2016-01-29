require_relative 'spec_init'

context "Record Macro" do
  sink = Telemetry::Controls::Sink::Macro::RecordAny.example

  signal = :something

  test "Creates record method" do
    assert(sink.respond_to? "record_#{signal}")
  end

  test "Creates records method" do
    assert(sink.respond_to? "#{signal}_records")
  end

  test "Creates recorded method" do
    assert(sink.respond_to? "recorded_#{signal}?")
  end
end
