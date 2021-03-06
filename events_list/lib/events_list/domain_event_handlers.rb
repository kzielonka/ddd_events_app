# frozen_string_literal: true

class EventsList
  module DomainEventHandlers
    def self.handle(event)
      constants.map(&method(:const_get)).each { |h| h.new.handle(event) }
    end

    class TitleUpdated
      def handle(event)
        return unless event.is_a?(Events::DomainEvents::EventTitleUpdated)

        EventRecord.create(event.data[:id])
        EventRecord.where(id: event.data[:id])
                   .update_all(title: event.data[:title])
      end
    end

    class DescriptionUpdated
      def handle(event)
        return unless event.is_a?(Events::DomainEvents::EventDescriptionUpdated)

        EventRecord.create(event.data[:id])
        EventRecord.where(id: event.data[:id])
                   .update_all(description: event.data[:description])
      end
    end

    class TotalPlacesUpdated
      def handle(event)
        return unless event.is_a?(Events::DomainEvents::EventTotalPlacesUpdated)

        EventRecord.create(event.data[:id])
        EventRecord.where(id: event.data[:id])
                   .update_all(total_places: event.data[:total_places])
      end
    end

    class FreePlacesChanged
      def handle(event)
        return unless event.is_a?(Events::DomainEvents::EventFreePlacesChanged)

        EventRecord.create(event.data[:id])
        EventRecord.where(id: event.data[:id])
                   .update_all(free_places: event.data[:free_places])
      end
    end

    class Published
      def handle(event)
        return unless event.is_a?(Events::DomainEvents::EventPublished)

        EventRecord.create(event.data[:id])
        EventRecord.where(id: event.data[:id]).update_all(published: true)
      end
    end
  end
  private_constant :DomainEventHandlers
end
