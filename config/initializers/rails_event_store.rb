# frozen_string_literal: true

require 'rails_event_store'
require 'arkency/command_bus'

require 'events'
require 'events_list'

Rails.configuration.to_prepare do # rubocop:disable Metrics/BlockLength
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  Rails.configuration.events = Events.new(Rails.configuration.event_store)

  Rails.configuration.events_list = EventsList.new
  Rails.configuration.tickets_list = TicketsList.new

  Rails.configuration.event_store.tap do |store|
    store.subscribe(
      ->(ev) { Rails.configuration.events_list.handle_event(ev) },
      to: [
        Events::DomainEvents::EventTitleUpdated,
        Events::DomainEvents::EventDescriptionUpdated,
        Events::DomainEvents::EventTotalPlacesUpdated,
        Events::DomainEvents::EventFreePlacesChanged,
        Events::DomainEvents::EventPublished
      ]
    )

    store.subscribe(
      ->(ev) { Rails.configuration.tickets_list.handle_event(ev) },
      to: [
        Events::DomainEvents::EventTitleUpdated,
        Events::DomainEvents::EventDescriptionUpdated,
        Events::DomainEvents::TicketSold
      ]
    )
  end

  Rails.configuration.command_bus.tap do |bus|
    Events::Commands.constants.each do |const|
      bus.register(
        Events::Commands.const_get(const),
        ->(command) { Rails.configuration.events.execute_command(command) }
      )
    end
  end
end
