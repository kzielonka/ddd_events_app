class EventsController < ApplicationController
  def index
    @events = Rails.configuration.events_list.published_events
  end
end
