require 'events'

require 'tickets_list/event_record'
require 'tickets_list/ticket_record'
require 'tickets_list/domain_event_handlers'

class TicketsList
  def handle_event(event)
    DomainEventHandlers.handle(event)
  end

  def find(id)
    TicketRecord.find(id).to_ticket
  rescue ActiveRecord::RecordNotFound
    :not_found
  end

  def find_for_event(event_id)
    TicketRecord.where(event_id: String(event_id)).includes(:event).collect(&:to_ticket)
  end

  Ticket = Struct.new(:id, :code, :places, :event)
  Event = Struct.new(:id, :title, :description) do
    def to_event
      self
    end
  end
end
