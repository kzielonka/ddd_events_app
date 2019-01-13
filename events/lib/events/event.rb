require "aggregate_root"

class Events
  class Event
    include AggregateRoot

    class ValidationError < StandardError
      def initialize(errors)
        super("validation error")
        @errors = errors
      end

      attr_reader :errors

      alias validation_errors errors
    end

    def initialize(id)
      @id = ValueObjects::EventId.new(id)

      @created = false
      @published = false

      @title = ValueObjects::Title.new(:not_set)
      @description = ValueObjects::Title.new(:not_set)
      @number_of_tickets = ValueObjects::NumberOfTickets.new(:not_set)
    end

    def create
      raise Errors::EventAlreadyCreated if @created
      apply DomainEvents::EventCreated.new(data: { id: @id.to_s })
    end

    def update_title(title)
      raise Errors::EventNotFound unless @created
      raise Errors::PublishedEventCantBeUpdated if @published

      title = ValueObjects::Title.new(title)
      raise ValidationError, title.validate(true) unless title.valid?(true)

      apply DomainEvents::EventTitleUpdated.new(
        data: {
          id: @id.to_s,
          title: title.to_s,
        }
      )
    end

    def update_description(description)
      raise Errors::EventNotFound unless @created
      raise Errors::PublishedEventCantBeUpdated if @published

      description = ValueObjects::Description.new(description)
      raise ValidationError, description.validate(true) unless description.valid?(true)

      apply DomainEvents::EventDescriptionUpdated.new(
        data: {
          id: @id.to_s,
          description: description.to_s,
        }
      )
    end

    def update_number_of_tickets(num)
      raise Errors::EventNotFound unless @created
      raise Errors::PublishedEventCantBeUpdated if @published

      num = ValueObjects::NumberOfTickets.new(num)
      raise ValidationError, num.validate unless num.valid?

      apply DomainEvents::EventNumberOfTicketsUpdated.new(
        data: {
          id: @id.to_s,
          number_of_tickets: num.to_i
        }
      )
    end

    def publish
      errors = {
        title: @title.validate(false),
        description: @description.validate(false),
        number_of_tickets: @number_of_tickets.validate,
      }
      raise ValidationError, errors unless errors.values.all?(&:empty?)
      apply DomainEvents::EventPublished.new(data: { id: @id.to_s })#, published_at: Time.now.utc })
    end

    class EventDetails
      def initialize(data)
        data = Hash(data)
        @title = String(data[:title]).strip.freeze
        @description = String(data[:description]).strip.freeze
      end

      def self.factory_empty
        new({})
      end

      attr_reader :title
      attr_reader :description
    end

    private

    on(DomainEvents::EventCreated) do |_|
      @created = true
    end

    on(DomainEvents::EventPublished) do |_|
      @published = true
    end

    on(DomainEvents::EventTitleUpdated) do |event|
      @title = ValueObjects::Title.new(event.data[:title])
    end

    on(DomainEvents::EventDescriptionUpdated) do |event|
      @description = ValueObjects::Description.new(event.data[:description])
    end

    on(DomainEvents::EventNumberOfTicketsUpdated) do |event|
      @number_of_tickets = ValueObjects::NumberOfTickets.new(event.data[:number_of_tickets])
    end
  end
  private_constant :Event
end
