require_relative 'spec_init'

context "Configure a Receiver with Telemetry" do
  receiver = OpenStruct.new

  Telemetry.configure receiver

  test "Receiver has telemetry" do
    assert(receiver.telemetry.class == Telemetry)
  end
end
