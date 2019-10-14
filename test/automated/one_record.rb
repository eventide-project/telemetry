require_relative 'automated_init'

context "One Recorded Telemetry Signal" do
  context "Signal Is Not Recorded" do
    sink = Telemetry::Controls::Sink.example

    test "With predicate" do
      record = sink.one_record { |r| r.signal == :something }

      assert(record.nil?)
    end

    test "Without predicate" do
      record = sink.one_record

      assert(record.nil?)
    end
  end

  context "Signal Is Recorded Once" do
    sink = Telemetry::Controls::Sink.example

    control_record = sink.record(:something, 'some_time', 'some data')

    assert(control_record.instance_of?(Telemetry::Sink::Record))

    test "With predicate" do
      record = sink.one_record { |r| r.signal == :something }
      assert(record == control_record)

      record = sink.one_record { |r| r.signal == :something_else }
      assert(record.nil?)
    end

    test "Without predicate" do
      assert(sink.one_record == control_record)
    end
  end

  context "Signal Is Recorded More Than Once" do
    sink = Telemetry::Controls::Sink.example

    record_1 = sink.record(:something, 'some_time', 'some data')
    record_2 = sink.record(:something, 'some_time', 'other data')

    context "Multiple Records Match" do
      test "Raises error" do
        assert_raises Telemetry::Sink::Error do
          sink.one_record { |r| r.signal == :something }
        end
      end
    end

    context "One Record Matches" do
      record = nil

      test "Does not raise error" do
        refute_raises Telemetry::Sink::Error do
          record = sink.one_record { |r| r.data == 'other data' }
        end
      end

      test "Returns matching record" do
        assert(record == record_2)
      end
    end
  end
end
