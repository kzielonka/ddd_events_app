# frozen_string_literal: true

class RenameEventsListEventsNumberOfTicketsToTotalPlaces < ActiveRecord::Migration[5.2]
  def change
    rename_column :events_list_events, :total_number_of_tickets, :total_places
  end
end
