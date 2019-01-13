require "dry-struct"

class Events
  module Commands
    class Command < Dry::Struct::Value
      Invalid = Class.new(StandardError)

      def self.new(*)
        super
      rescue Dry::Struct::Error => doh
        raise Invalid, doh
      end
    end
    private_constant :Command

    class CreateEvent < Command
      attribute :id, Types::UUID

      alias event_id id
    end

    class UpdateEventDetails < Command
      attribute :event_id, Types::UUID
      attribute :title, Types::String
      attribute :description, Types::String
      attribute :number_of_tickets, Types::Integer
    end

    class PublishEvent < Command
      attribute :event_id, Types::UUID
    end
  end
end
