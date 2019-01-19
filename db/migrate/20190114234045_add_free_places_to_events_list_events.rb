class AddFreePlacesToEventsListEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events_list_events, :free_places, :integer, null: false, default: 0
  end
end
