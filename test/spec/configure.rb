require_relative 'spec_init'

describe "Configure a Receiver with Telemetry" do
  receiver = OpenStruct.new

  Telemetry.configure receiver

  specify "Receiver has telemetry" do
    assert(receiver.telemetry.class == Telemetry)
  end
end
