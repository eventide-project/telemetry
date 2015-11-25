require_relative 'spec_init'

describe "Sink Records Telemetry" do
  telemetry = Telemetry.new
  sink = Telemetry::Controls::Sink.example

  telemetry.register sink

  telemetry.record :something, 'some data'

  specify do
    sink.recorded? { |r| r.name == :something }
  end
end
