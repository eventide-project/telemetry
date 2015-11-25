class Telemetry
  module Controls
    module Sink
      class Example
        include Telemetry::Sink
      end

      def self.example
        Example.new
      end
    end
  end
end
