# frozen_string_literal: true

require 'dry-struct'

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
      attribute :event_id,     Types::UUID
      attribute :title,        Types::String
      attribute :description,  Types::String
      attribute :total_places, Types::Integer
    end

    class PublishEvent < Command
      attribute :event_id, Types::UUID
    end

    class BuyTicket < Command
      attribute :event_id,  Types::UUID
      attribute :ticket_id, Types::UUID
      attribute :places,    Types::Integer
    end
  end
end
