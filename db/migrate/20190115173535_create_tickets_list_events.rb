# frozen_string_literal: true

class CreateTicketsListEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets_list_events, id: false do |t|
      t.uuid    :id, null: false, index: { unique: true }
      t.string  :title, null: false, default: ''
      t.string  :description, null: false, default: ''
    end
  end
end
