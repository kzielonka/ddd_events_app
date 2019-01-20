# frozen_string_literal: true

require 'rails_event_store'

class Events
  module DomainEvents
    EventCreated = Class.new(RailsEventStore::Event)
    EventPublished = Class.new(RailsEventStore::Event)
    EventUnpublished = Class.new(RailsEventStore::Event)
    EventTitleUpdated = Class.new(RailsEventStore::Event)
    EventDescriptionUpdated = Class.new(RailsEventStore::Event)
    EventTotalPlacesUpdated = Class.new(RailsEventStore::Event)
    TicketSold = Class.new(RailsEventStore::Event)
    EventFreePlacesChanged = Class.new(RailsEventStore::Event)
  end
end
