class TicketsList
  module DomainEventHandlers
    def self.handle(event)
      constants.map(&method(:const_get)).each { |h| h.new.handle(event) }
    end

    class EventTitleUpdated
      def handle(event)
        return unless event.is_a?(Events::DomainEvents::EventTitleUpdated)
        EventRecord.create(event.data[:id])
        EventRecord.where(id: event.data[:id]).update_all(title: event.data[:title])
      end
    end

    class EventDescriptionUpdated
      def handle(event)
        return unless event.is_a?(Events::DomainEvents::EventDescriptionUpdated)
        EventRecord.create(event.data[:id])
        EventRecord.where(id: event.data[:id]).update_all(description: event.data[:description])
      end
    end

    class TicketSold
      def handle(event)
        return unless event.is_a?(Events::DomainEvents::TicketSold)
        EventRecord.create(event.data[:event_id])
        TicketRecord.create(event.data[:ticket_id])
        TicketRecord.where(id: event.data[:ticket_id]).update_all(event_id: event.data[:event_id], places: event.data[:places])
      end
    end
  end
  private_constant :DomainEventHandlers
end
