# frozen_string_literal: true

class CreateTicketsListTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets_list_tickets, id: false do |t|
      t.uuid       :id, null: false, index: { unique: true }
      t.references :event, index: true, foreign_key: { to_table: :tickets_list_events }, type: :uuid
      t.integer    :places, null: false, default: 0
      t.string     :code, null: false, default: ''
    end
  end
end
