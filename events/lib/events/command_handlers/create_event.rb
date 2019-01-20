# frozen_string_literal: true

class Events
  class CommandHandlers
    class CreateEvent < Handler
      def handle(command)
        return unless command.is_a?(Commands::CreateEvent)

        with_event(command.event_id, &:create)
      end
    end
  end
end
