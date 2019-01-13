require "events"

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


