# frozen_string_literal: true

class Events
  module ValueObjects
    class EventId
      def initialize(event_id)
        @event_id = String(event_id)
        @event_id.dup.freeze unless @event_id.frozen?
      end

      def to_s
        @event_id
      end
    end
  end
end
