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

    def initialize(id, uuid_generator = proc { 'uuid' })
      @id = ValueObjects::EventId.new(id)
      @uuid_generator = uuid_generator

      @created = false
      @published = false

      @title = ValueObjects::Title.new(:not_set)
      @description = ValueObjects::Title.new(:not_set)
      @total_places = ValueObjects::TotalPlaces.new(:not_set)
      @sold_places = ValueObjects::Places.new(0)
    end

    def create
      raise Errors::EventAlreadyCreated if @created
      apply DomainEvents::EventCreated.new(data: { id: @id.to_s })
    end

    def buy_ticket(ticket_id, places)
      places = Integer(places)

      raise Errors::EventNotFound unless @created
      raise Errors::EventIsNotPublic unless @published
      raise Errors::PlacesMustBeNonZeroPositive unless places > 0

      free_places = @total_places.to_i - @sold_places.to_i
      raise Errors::NotEnoughTickets if free_places < places

      apply DomainEvents::TicketSold.new(
        data: {
          event_id: @id.to_s,
          ticket_id: ticket_id,
          places: places,
        }
      )

      apply DomainEvents::EventFreePlacesChanged.new(
        data: {
          id: @id.to_s,
          free_places: free_places - places
        }
      )
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

    def update_total_places(num)
      raise Errors::EventNotFound unless @created
      raise Errors::PublishedEventCantBeUpdated if @published

      num = ValueObjects::TotalPlaces.new(num)
      raise ValidationError, num.validate unless num.valid?

      apply DomainEvents::EventTotalPlacesUpdated.new(
        data: {
          id: @id.to_s,
          total_places: num.to_i
        }
      )

      free_places = @total_places.to_i - @sold_places.to_i
      apply DomainEvents::EventFreePlacesChanged.new(
        data: {
          id: @id.to_s,
          free_places: free_places,
        }
      )
    end

    def publish
      errors = {
        title: @title.validate(false),
        description: @description.validate(false),
        total_places: @total_places.validate,
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

    on(DomainEvents::EventTotalPlacesUpdated) do |event|
      @total_places = ValueObjects::TotalPlaces.new(event.data[:total_places])
    end

    on(DomainEvents::TicketSold) do |event|
      @sold_places = ValueObjects::Places.new(@sold_places.to_i + event.data[:places])
    end

    on(DomainEvents::EventFreePlacesChanged) do |_|
      nil
    end
  end
  private_constant :Event
end
