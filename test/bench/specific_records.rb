require_relative './bench_init'

context "Record Specific Telemetry" do
  context "Declared Telemetry" do
    sink = Telemetry::Controls::Sink::Macro.example

    time = Telemetry::Controls::Time.example

    sink.record_something time, 'some macro data'

    test "Recorded" do
      recorded = sink.recorded_something? { |r| r.data == 'some macro data' }
      assert(recorded)
    end
  end

  context "Undeclared Telemetry" do
    sink = Telemetry::Controls::Sink::Macro.example

    time = Telemetry::Controls::Time.example

    sink.record :something_else, time, 'some macro data'

    test "Is not recorded" do
      recorded = sink.recorded? { |r| r.signal == :something_else }
      assert(!recorded)
    end
  end
end
