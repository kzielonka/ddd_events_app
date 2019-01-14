require 'events_list/event'
require 'events_list/event_record'
require 'events_list/domain_event_handlers'

class EventsList
  def handle_event(event)
    DomainEventHandlers.handle(event)
  end

  def all_events
    EventRecord.all.map(&:to_event)
  end

  def find(id)
    EventRecord.find(id).to_event
  end
end
