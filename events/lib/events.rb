require "events/errors"
require "events/types"
require "events/commands"
require "events/domain_events"
require "events/value_objects"
require "events/event"
require "events/command_handlers"

require "securerandom"

class Events
  def initialize(event_store, uuid_generator = proc { SecureRandom.uuid })
    @command_handlers = CommandHandlers.new(event_store, uuid_generator)
  end

  def execute_command(command)
    @command_handlers.handle(command)
  end
end
