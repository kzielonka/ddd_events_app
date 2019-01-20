# frozen_string_literal: true

class Events
  module Errors
    EventAlreadyCreated = Class.new(StandardError)
    EventNotFound = Class.new(StandardError)
    PublishedEventCantBeUpdated = Class.new(StandardError)
    EventIsNotPublic = Class.new(StandardError)
    NotEnoughTickets = Class.new(StandardError)
    PlacesMustBeNonZeroPositive = Class.new(StandardError)

    class InvalidEventDetails < StandardError
      def initialize(errors)
        super('invalid event details')
        @title_errors = errors.fetch(:title, [])
        @description_errors = errors.fetch(:description, [])
        @number_of_tickets_errors = errors.fetch(:number_of_tickets, [])
      end

      attr_reader :title_errors, :description_errors, :number_of_tickets_errors
    end
  end
end
