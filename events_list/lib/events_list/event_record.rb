require 'active_record'

class EventsList
  class EventRecord < ActiveRecord::Base
    self.table_name  = 'events_list_events'
    self.primary_key = 'id'

    scope :published, -> { where(published: true) }

    def self.create(id)
      super(id: id)
    rescue ActiveRecord::RecordNotUnique
      nil
    end

    def to_event
      Event.new(id, title, description, total_places, free_places, published)
    end
  end
  private_constant :EventRecord
end
