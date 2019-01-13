require "events/errors"
require "events/types"
require "events/commands"
require "events/domain_events"
require "events/value_objects"
require "events/event"
require "events/command_handlers"

class Events
  def initialize(event_store)
    @command_handlers = CommandHandlers.new(event_store)
  end

  def execute_command(command)
    @command_handlers.handle(command)
  end
end
