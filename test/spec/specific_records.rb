require_relative 'spec_init'

describe "Record Specific Telemetry" do
  describe "Declared Telemetry" do
    sink = Telemetry::Controls::Sink::Macro.example

    time = Controls::Time.example

    sink.record_something time, 'some macro data'

    specify "Recorded" do
      recorded = sink.recorded_something? { |r| r.data == 'some macro data' }
      assert(recorded)
    end
  end

  describe "Undeclared Telemetry" do
    sink = Telemetry::Controls::Sink::Macro.example

    time = Controls::Time.example

    sink.record :something_else, time, 'some macro data'

    specify "Is not recorded" do
      recorded = sink.recorded? { |r| r.signal == :something_else }
      refute(recorded)
    end
  end
end
