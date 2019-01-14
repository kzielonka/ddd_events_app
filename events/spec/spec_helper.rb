require 'events'

class EventStoreFake
  def initialize
    @streams = Hash.new { |h, k| h[k] = [] }
  end

  def all_events
    @streams.values.flatten
  end

  def read
    self
  end

  def in_batches
    self
  end

  def stream(name)
    @streams[String(name)]
  end

  def publish(events, options)
    @streams[String(options.fetch(:stream_name))].concat(events)
  end
end

require 'rspec/expectations'

RSpec::Matchers.define :have_events do |*expected|
  match do |actual|
    actual.all_events.collect(&:class) == expected.collect(&:class) &&
      actual.all_events.collect(&:data) == expected.collect(&:data)
  end

  failure_message do |actual|
    msg = "Expected events are:\n\n\n"
    expected.each { |ev| msg += "\t#{ev.class}\n\t#{ev.data}\n\n" }
    msg += "\nbut got:\n\n\n"
    actual.all_events.each { |ev| msg += "\t#{ev.class}\n\t#{ev.data}\n\n" }
    msg
  end
end

RSpec::Matchers.define :have_event do |expected|
  match do |actual|
    actual.all_events.any? do |ev|
      ev.class == expected.class && ev.data == expected.data
    end
  end

  failure_message do |_|
    msg = "Expected event is:\n\n\n"
    msg += "\t#{expected.class}\n\t#{expected.data}\n\n"
    msg += "\nbut got:\n\n\n"
    actual.all_events.each { |ev| msg += "\t#{ev.class}\n\t#{ev.data}\n\n" }
    msg
  end
end
