# telemetry

In-process telemetry based on observers

## Synopsis

```ruby
require 'telemetry'

class MyClass
  def telemetry
    @telemetry ||= Telemetry.build
  end

  def my_useful_method
    telemetry.record(:start)
    puts "doing stuff"

    telemetry.record(:in_progress, MyData.new("useful data"))

    puts "did stuff"
    telemetry.record(:end)
  end
end

MyData = Struct.new(:info)

class MySink
  include Telemetry::Sink

  record :start
  record :in_progress
  record :end
end

instance = MyClass.new
sink = MySink.new

instance.telemetry.register(sink)

instance.my_useful_method

record = sink.one_record { |record| record.signal == :start } # #<struct Telemetry::Sink::Record signal=:start, time="2018-08-27T13:21:23.47663Z", data=nil>

```

Telemetry is a library which allows for custom instrumentation of your ruby code. It provides an interface
for writing events (or "[signals](https://en.wikipedia.org/wiki/Signal_(IPC))"), which in turn will be written to any registered sinks. A sink is simply a class
which receives a record of an event. The built in `Telemetry::Sink` will write any recorded events
to an in memory array, and provides several convenience methods for inspecting what was written.


## When should telemetry be used?

Observability, or "knowing what an object did", is a broadly useful property for an object to have. Some common usages would include (but are not limited to) verifying behaviour in an automated test, logging, or gathering performance metrics. If your objects are observable, you do not need mocks, as mocks are a crude way of working around the lack of observability.


## What is a "sink" and why do I need one?

A sink is a [common pattern](https://en.wikipedia.org/wiki/Sink_(computing)) in evented systems. It allows you to decouple the recording of events, with the handling of recorded events. If there are no sinks registered, the recording of an event is essentially a no-op. In addition to the built in memory sink, you could implement a custom sink to handle the recorded events in any way you like (send to logstash, send to statsd, send to newrelic, etc).


## API

### Telemetry

The api for `Telemetry` is quite simple

 - _`record(signal, <optional anything>data)`_ records a signal
 - _`register(sink)`_ register a new sink

The protocol for a sink is also quite simple.

 - _`record(signal, <string>timestamp, <optional>data)`_ receive a recorded signal

Any object which responds to that method may be used as a sink.

### Telemetry::Sink

`Telemetry::Sink` is a mixin to provide in-memory sink functionality. To use it,
simply mix it into any class. It also requires you to declare what type of signals
it handles with either `record :signal` or `record_any` if you do not want to restrict
what it handles.

When you use `record :signal` in a class declaration, several convenience methods are defined for you:

 - _`record_<signal>(time, data)`_ convenience methods for recording the declared symbol
 - _`<signal>_records`_ list of records that have been recorded for that signal
 - _`recorded_<signal>?(block)`_ returns any records of the declared symbol for which the
  passed in block returns `true`.
 - _`recorded_<signal>_once?(<optional>block)`_ returns `true` if only a single record of the declared signal was recorded. If a block is passed in, that block must also return `true`.

`Telemetry::Sink` stores all records in `records`. However, it also provides several
convenience methods.

 - _`records`_ array of all records
 - _`record?(:signal)`_ returns true if the given signal is supported by this sink
 - _`record(signal, timestamp, <optional>data, force: nil)`_ satisfies the Sink protocol. Also includes
  the `force:` named argument to override the built in signal filtering
 - _`recorded?(<optional>block)`_ returns `true` if any signals have been recorded. If a block is given, it must also return `true`_ for at least one record.
 - _`recorded_once?(<optional>block)`_ returns `true` if exactly one signal has been recorded. If a block is given, it must also return true.

Records are instance of `Telemetry::Sink::Record` and are structs with the following fields

 - `:signal`
 - `:time`
 - `:data`


## Configure

This library was written according to [The Doctrine of Useful Objects](http://docs.eventide-project.org/user-guide/useful-objects.html). As such, it can be configured as `telemetry`.

```ruby
class MyClass
  dependency :telemetry

  def self.build
    instance = new

    Telemetry.configure(instance)

    instance
  end

  def my_useful_method
    telemetry.record(:start)
    puts "doing stuff"

    telemetry.record(:in_progress, MyData.new("useful data"))

    puts "did stuff"
    telemetry.record(:end)
  end
end
```


## License

The `telemetry` library is released under the [MIT License](https://github.com/telemetry/blob/master/MIT-License.txt).
