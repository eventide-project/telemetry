class Telemetry
  module Dependency
    def telemetry
      @telemetry ||= Telemetry.build
    end
  end
end
