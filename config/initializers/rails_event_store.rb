require 'rails_event_store'
require 'arkency/command_bus'

require 'events'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  Rails.configuration.events = Events.new(Rails.configuration.event_store)

  Rails.configuration.command_bus.tap do |bus|
    Events::Commands.constants.each do |const|
      bus.register(
        Events::Commands.const_get(const),
        ->(command) { Rails.configuration.events.execute_command(command) },
      )
    end
  end
end
