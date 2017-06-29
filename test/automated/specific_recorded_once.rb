require_relative 'automated_init'

context "Record Specific Telemetry Once" do
  context "Signal Recorded Once" do
    sink = Telemetry::Controls::Sink::Macro.example

    time = Telemetry::Controls::Time.example

    sink.record_something time, 'some macro data'

    test "Recorded once (with predicate)" do
      recorded_once = sink.recorded_something_once? { |r| r.data == 'some macro data' }
      assert(recorded_once)
    end

    test "Recorded once (without predicate)" do
      recorded_once = sink.recorded_something_once?
      assert(recorded_once)
    end
  end

  context "Signal Recorded More Than Once" do
    sink = Telemetry::Controls::Sink::Macro.example

    time = Telemetry::Controls::Time.example

    2.times do
      sink.record_something time, 'some macro data'
    end

    test "Not recorded once (with predicate)" do
      recorded_once = sink.recorded_something_once? { |r| r.data == 'some macro data' }
      refute(recorded_once)
    end

    test "Not recorded once (without predicate)" do
      recorded_once = sink.recorded_something_once?
      refute(recorded_once)
    end
  end
end
