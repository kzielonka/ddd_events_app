require_relative "./command_handlers/handler"

Dir[File.join(File.dirname(__FILE__), "command_handlers", "*.rb")].each { |f| require f }

class Events
  class CommandHandlers
    def initialize(event_store, uuid_generator)
      @event_store = event_store
      @uuid_generator = uuid_generator
    end

    def handle(command)
      handlers.each { |h| h.handle(command) }
    end

    private

    def handlers
      @handlers ||= self.class.handlers.map { |h| h.new(@event_store, @uuid_generator) }
    end

    def self.handlers
      constants.map(&method(:const_get))
    end
  end
  private_constant :CommandHandlers
end
