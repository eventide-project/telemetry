class Telemetry
  module Controls
    module Sink
      class Example
        include Telemetry::Sink

        record_any
      end

      def self.example
        Example.new
      end

      module RecordsOther
        class Example
          include Telemetry::Sink

          record :something_else
        end

        def self.example
          Example.new
        end
      end

      module Macro
        class Example
          include Telemetry::Sink

          record :something
        end

        def self.example
          Example.new
        end

        module RecordAny
          class Example
            include Telemetry::Sink

            record_any

            record :something
          end

          def self.example
            Example.new
          end
        end
      end
    end
  end
end
