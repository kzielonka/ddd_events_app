# frozen_string_literal: true

class Events
  class CommandHandlers
    class UpdateEventDetails < Handler
      def handle(command)
        return unless command.is_a?(Commands::UpdateEventDetails)

        with_event(command.event_id) do |event|
          errors = ErrorsContainer.new

          update_title(command, event, errors)
          update_description(command, event, errors)
          update_total_places(command, event, errors)

          raise Errors::InvalidEventDetails, errors unless errors.empty?
        end
      end

      private

      def update_title(command, event, errors)
        event.update_title(command.title)
      rescue Event::ValidationError => error
        errors.add(:title, error.validation_errors)
      end

      def update_description(command, event, errors)
        event.update_description(command.description)
      rescue Event::ValidationError => error
        errors.add(:description, error.validation_errors)
      end

      def update_total_places(command, event, errors)
        event.update_total_places(command.total_places)
      rescue Event::ValidationError => error
        errors.add(:total_places, error.validation_errors)
      end

      class ErrorsContainer
        def initialize
          @errors = {
            title: [].freeze,
            description: [].freeze,
            total_places_errors: [].freeze
          }
        end

        def add(field, errors)
          @errors[field] = Array(errors).collect(&:to_s)
        end

        def empty?
          @errors.values.all?(&:empty?)
        end

        def fetch(*args)
          @errors.fetch(*args)
        end
      end
      private_constant :ErrorsContainer
    end
  end
end
