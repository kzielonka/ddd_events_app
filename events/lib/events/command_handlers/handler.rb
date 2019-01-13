class Events
  class CommandHandlers
    class Handler
      def initialize(event_store)
        @event_store = event_store
      end

      private

      def with_event(id)
        stream = "Event$#{id}"
        event = Event.new(id)
        event.load(stream, event_store: @event_store)
        yield event
        event.store(event_store: @event_store)
      end
    end
    private_constant :Handler
  end
end
