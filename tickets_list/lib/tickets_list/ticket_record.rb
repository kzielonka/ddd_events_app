require 'active_record'

class TicketsList
  class TicketRecord < ActiveRecord::Base
    self.table_name  = 'tickets_list_tickets'
    self.primary_key = 'id'

    belongs_to :event, class_name: 'TicketsList::EventRecord'

    def self.create(id)
      super(id: id)
    rescue ActiveRecord::RecordNotUnique
      nil
    end

    def to_ticket
      Ticket.new(id, code, places, event.to_event)
    end
  end
  private_constant :EventRecord
end
