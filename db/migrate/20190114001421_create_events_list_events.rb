class CreateEventsListEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events_list_events, id: false do |t|
      t.uuid    :id, null: false, index: { unique: true }
      t.string  :title, null: false, default: ''
      t.string  :description, null: false, default: ''
      t.integer :total_number_of_tickets, null: false, default: 0
      t.boolean :published, null: false, default: false, index: true
    end
  end
end
