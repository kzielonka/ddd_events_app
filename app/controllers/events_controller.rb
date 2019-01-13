class EventsController < ApplicationController
  def new
    @event = EventForm.new
  end

  def create
    @event = EventForm.new(event_attrs)
    event_id = SecureRandom.uuid

    command_bus.(Events::Commands::CreateEvent.new(id: event_id))
    command_bus.(Events::Commands::UpdateEventDetails.new(
      event_id: event_id,
      title: @event.title,
      description: @event.description,
      number_of_tickets: @event.number_of_tickets.to_i,
    ))
    render action: :new
  rescue Events::Errors::InvalidEventDetails => error
    @event.add_errors(error)
    render action: :new
  end

  private

  def event_attrs
    params.require(:events_controller_event_form)
          .permit(:title, :description, :number_of_tickets)
  end

  class EventForm
    include ActiveModel::Model

    attr_accessor :title, :description, :number_of_tickets

    def add_errors(validation_errors)
      validation_errors.title_errors.each { |e| @event.errors.add(:title, e) }
      validation_errors.description_errors.each { |e| @event.errors.add(:description, e) }
      validation_errors.number_of_tickets_errors.each { |e| @event.errors.add(:number_of_tickets, e) }
    end
  end
  private_constant :EventForm
end
