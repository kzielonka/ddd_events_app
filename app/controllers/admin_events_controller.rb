class AdminEventsController < ApplicationController
  def index
    @events = Rails.configuration.events_list.all_events
  end

  def new
    @event = EventForm.new
  end

  def show
    @event = Rails.configuration.events_list.find(params[:id])
    @tickets = Rails.configuration.tickets_list.find_for_event(params[:id])
  end

  def edit
    ev_data = Rails.configuration.events_list.find(params[:id])
    @event = EventForm.new(
      id: ev_data.id,
      title: ev_data.title,
      description: ev_data.description,
      total_places: ev_data.total_places,
    )
  end

  def update
    @event = EventForm.new(event_attrs)
    @event.id = params[:id]

    command_bus.(Events::Commands::UpdateEventDetails.new(
      event_id: @event.id,
      title: @event.title,
      description: @event.description,
      total_places: @event.total_places.to_i,
    ))

    if params[:commit] == 'publish'
      command_bus.(Events::Commands::PublishEvent.new(
        event_id: @event.id,
      ))
    end

    redirect_to admin_events_path
  rescue Events::Errors::InvalidEventDetails => error
    @event.add_errors(error)
    render action: :edit
  end

  def create
    @event = EventForm.new(event_attrs)
    event_id = SecureRandom.uuid

    command_bus.(Events::Commands::CreateEvent.new(id: event_id))
    command_bus.(Events::Commands::UpdateEventDetails.new(
      event_id: event_id,
      title: @event.title,
      description: @event.description,
      total_places: @event.total_places.to_i,
    ))

    if params[:commit] == 'publish'
      command_bus.(Events::Commands::PublishEvent.new(
        event_id: event_id,
      ))
    end

    redirect_to admin_events_path
  rescue Events::Errors::InvalidEventDetails => error
    @event.add_errors(error)
    render action: :new
  end

  private

  def event_attrs
    params.require(:admin_events_controller_event_form)
          .permit(:title, :description, :total_places)
  end

  class EventForm
    include ActiveModel::Model

    attr_accessor :id, :title, :description, :total_places

    def add_errors(validation_errors)
      validation_errors.title_errors.each { |e| errors.add(:title, e) }
      validation_errors.description_errors.each { |e| errors.add(:description, e) }
      validation_errors.total_places_errors.each { |e| errors.add(:total_places, e) }
    end
  end
  private_constant :EventForm
end
