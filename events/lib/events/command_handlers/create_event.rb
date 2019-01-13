class Events
  class CommandHandlers
    class CreateEvent < Handler
      def handle(command)
        return unless command.is_a?(Commands::CreateEvent)
        with_event(command.event_id) do |event|
          event.create
        end
      end
    end
  end
end
