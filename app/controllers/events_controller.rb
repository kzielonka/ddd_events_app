class EventsController < ApplicationController
  def index
    @events = Rails.configuration.events_list.published_events
  end

  def show
    @event = Rails.configuration.events_list.find(params[:id])
    @buy = BuyForm.new(places: 0)
  end

  def buy
    @event = Rails.configuration.events_list.find(params[:id])
    @buy = BuyForm.new(buy_attrs)
    command_bus.(Events::Commands::BuyTicket.new(
      event_id: params[:id],
      places:   @buy.places,
    ))
    redirect_to events_path
  rescue Events::Errors::EventNotFound
    render :not_found
  rescue Events::Errors::EventIsNotPublic
    render :not_found
  rescue Events::Errors::NotEnoughTickets
    @buy.errors[:places] << 'not enough places'
    render :show
  end

  private

  def buy_attrs
    params.require(:events_controller_buy_form)
          .permit(:places)
  end

  class BuyForm
    include ActiveModel::Model

    attr_accessor :places
  end
  private_constant :BuyForm
end
