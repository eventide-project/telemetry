require_relative 'automated_init'

context "Detect Recorded Telemetry Once" do
  context "Signal Is Not Recorded" do
    sink = Telemetry::Controls::Sink.example

    test "With predicate" do
      refute(sink.recorded_once? { |r| r.signal == :something })
    end

    test "Without predicate" do
      refute(sink.recorded_once?)
    end
  end

  context "Signal Is Recorded Once" do
    sink = Telemetry::Controls::Sink.example

    sink.record :something, 'some_time', 'some data'

    test "With predicate" do
      assert(sink.recorded_once? { |r| r.signal == :something })
      refute(sink.recorded_once? { |r| r.signal == :something_else })
    end

    test "Without predicate" do
      assert(sink.recorded_once?)
    end
  end

  context "Signal Is Recorded More Than Once" do
    sink = Telemetry::Controls::Sink.example

    2.times do
      sink.record :something, 'some_time', 'some data'
    end

    test "With predicate" do
      refute(sink.recorded_once? { |r| r.signal == :something })
    end

    test "Without predicate" do
      refute(sink.recorded_once?)
    end
  end
end
