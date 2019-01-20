# frozen_string_literal: true

class Events
  class CommandHandlers
    class PublishEvent < Handler
      def handle(command)
        return unless command.is_a?(Commands::PublishEvent)

        with_event(command.event_id, &:publish)
      rescue Event::ValidationError => error
        raise Errors::InvalidEventDetails, error.validation_errors
      end
    end
  end
end
