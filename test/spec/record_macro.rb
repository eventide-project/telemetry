require_relative 'spec_init'

describe "Record Macro" do
  sink = Telemetry::Controls::Sink::Macro::RecordAny.example

  signal = :something

  specify "Creates record method" do
    assert(sink.respond_to? "record_#{signal}")
  end

  specify "Creates records method" do
    assert(sink.respond_to? "#{signal}_records")
  end

  specify "Creates recorded method" do
    assert(sink.respond_to? "recorded_#{signal}?")
  end
end
