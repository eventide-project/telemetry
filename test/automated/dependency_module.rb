require_relative 'automated_init'

context "Dependency Module" do
  Example = Class.new do
    include Telemetry::Dependency
  end

  obj = Example.new

  test "Adds the telemetry attribute" do
    assert(obj.respond_to? :telemetry)
  end

  test "Records Telemetry" do
    refute_raises do
      obj.telemetry.record(:some_signal, 'some data')
    end
  end
end
