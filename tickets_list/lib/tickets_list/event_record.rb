# frozen_string_literal: true

require 'active_record'

class TicketsList
  class EventRecord < ActiveRecord::Base
    self.table_name  = 'tickets_list_events'
    self.primary_key = 'id'

    def self.create(id)
      super(id: id)
    rescue ActiveRecord::RecordNotUnique
      nil
    end

    def to_event
      Event.new(id, title, description)
    end
  end
  private_constant :EventRecord
end
