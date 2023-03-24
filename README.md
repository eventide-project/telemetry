# telemetry

In-process telemetry based on observers

## Synopsis

```ruby
require 'telemetry'

class Something
  def telemetry
    @telemetry ||= Telemetry.build
  end

  def some_method
    telemetry.record(:start)
    puts "doing stuff"

    telemetry.record(:in_progress, TelemetryData.new("useful data"))

    puts "did stuff"
    telemetry.record(:end)
  end
end

TelemetryData = Struct.new(:info)

class TelemetrySink
  include Telemetry::Sink

  record :start
  record :in_progress
  record :end
end

instance = Something.new
sink = TelemetrySink.new

instance.telemetry.register(sink)

instance.some_method

record = sink.one_record { |record| record.signal == :start }
# => #<struct Telemetry::Sink::Record signal=:start, time="2018-08-27T13:21:23.47663Z", data=nil>
```

Telemetry is a library which allows for custom instrumentation of your ruby code. It provides an interface for recording signals, which in turn will be written to any registered sinks. A sink is simply a class
which receives a record of an event. The built in `Telemetry::Sink` will write any recorded events to an in memory array, and provides several convenience methods for inspecting what was written.

## When Should Telemetry Be Used?

Observability, or "knowing what an object did", is a broadly useful property for an object to have. Some common usages would include (but are not limited to) verifying behavior in an automated test, logging, or gathering performance metrics. If your objects are observable, you do not need mocks, as mocks are a crude way of working around the lack of observability.

## What Is a "Sink" and Why Do I Need One?

A sink is a [common pattern](https://en.wikipedia.org/wiki/Sink_(computing)) in evented systems. It allows you to decouple the recording of events, with the handling of recorded events. If there are no sinks registered, the recording of an event is essentially a no-op. In addition to the built-in memory sink, you could implement a custom sink to handle the recorded events in any way you like (send to logstash, send to statsd, send to New Relic, etc).

## API

### Telemetry

The api for `Telemetry` is quite simple

- `record(signal, data=nil)` records a signal with optional, arbitrary data
- `register(sink)` register a new sink

The protocol for a sink is also quite simple.

- `record(signal, timestamp, data)` receive a recorded signal

Any object which responds to that method may be used as a sink.

### Telemetry::Sink

`Telemetry::Sink` is a mixin that provides in-memory sink functionality.

To use it, mix it into any class and declare what type of signals
it records.

- `record :some_signal` registers `:some_signal` as a something that the sink can record
- `record_any` allows the sink to record any signal without having to pre-define the signals statically.

When a signal is registered with `record :some_signal`, several convenience methods are defined:

- `record_<signal>(time, data)` convenience methods for recording the declared symbol
- `<signal>_records` list of records that have been recorded for that signal
- `recorded_<signal>?(&predicate_block)` returns any records of the declared symbol for which the predicate evaluates to `true`
- `recorded_<signal>_once?(&predicate_block)` returns `true` if a single record of the declared signal was recorded. If a predicate block is passed in, that block must also return `true`.

`Telemetry::Sink` stores all records in `records`. However, it also provides several convenience methods.

- `records` array of all records
- `record?(:signal)` returns true if the given signal is supported by this sink
- `record(signal, timestamp, data=nil, force: nil)` satisfies the Sink protocol. The optional `force` named argument causes the signal to be recorded even if the signal is not registered as recordable by the sink
- `recorded?(&predicate_block)` returns `true` if any signals have been recorded. If a block is given, it must also return `true` for at least one record.
- `recorded_once?(&predicate_block)` returns `true` if exactly one signal has been recorded. If a block is given, it must also return true.

Records are instance of `Telemetry::Sink::Record` and are structs with the following attributes:

- `signal`
- `time`
- `data`

## Configure

This library was written according to [The Doctrine of Useful Objects](http://docs.eventide-project.org/user-guide/useful-objects.html). As such, it can be configured as `telemetry`.

```ruby
class Something
  dependency :telemetry

  def self.build
    instance = new

    Telemetry.configure(instance)

    instance
  end

  def some_method
    telemetry.record(:start)
    puts "doing stuff"

    telemetry.record(:in_progress, TelemetryData.new("useful data"))

    puts "did stuff"
    telemetry.record(:end)
  end
end
```

## License

The `telemetry` library is released under the [MIT License](
https://github.com/eventide-project/telemetry/blob/master/MIT-License.txt).
