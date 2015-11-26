require_relative 'spec_init'

describe "Record Macro" do
  sink = Telemetry::Controls::Sink::Macro::RecordAny.example

  name = :something

  specify "Creates record method" do
    assert(sink.respond_to? "record_#{name}")
  end

  specify "Creates records method" do
    assert(sink.respond_to? "#{name}_records")
  end

  specify "Creates recorded method" do
    assert(sink.respond_to? "recorded_#{name}?")
  end
end
