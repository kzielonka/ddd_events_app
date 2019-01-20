# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_115_173_623) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'event_store_events', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'event_type', null: false
    t.binary 'metadata'
    t.binary 'data', null: false
    t.datetime 'created_at', null: false
    t.index ['created_at'], name: 'index_event_store_events_on_created_at'
    t.index ['event_type'], name: 'index_event_store_events_on_event_type'
  end

  create_table 'event_store_events_in_streams', id: :serial, force: :cascade do |t|
    t.string 'stream', null: false
    t.integer 'position'
    t.uuid 'event_id', null: false
    t.datetime 'created_at', null: false
    t.index ['created_at'], name: 'index_event_store_events_in_streams_on_created_at'
    t.index %w[stream event_id], name: 'index_event_store_events_in_streams_on_stream_and_event_id', unique: true
    t.index %w[stream position], name: 'index_event_store_events_in_streams_on_stream_and_position', unique: true
  end

  create_table 'events_list_events', id: false, force: :cascade do |t|
    t.uuid 'id', null: false
    t.string 'title', default: '', null: false
    t.string 'description', default: '', null: false
    t.integer 'total_places', default: 0, null: false
    t.boolean 'published', default: false, null: false
    t.integer 'free_places', default: 0, null: false
    t.index ['id'], name: 'index_events_list_events_on_id', unique: true
    t.index ['published'], name: 'index_events_list_events_on_published'
  end

  create_table 'tickets_list_events', id: false, force: :cascade do |t|
    t.uuid 'id', null: false
    t.string 'title', default: '', null: false
    t.string 'description', default: '', null: false
    t.index ['id'], name: 'index_tickets_list_events_on_id', unique: true
  end

  create_table 'tickets_list_tickets', id: false, force: :cascade do |t|
    t.uuid 'id', null: false
    t.uuid 'event_id'
    t.integer 'places', default: 0, null: false
    t.string 'code', default: '', null: false
    t.index ['event_id'], name: 'index_tickets_list_tickets_on_event_id'
    t.index ['id'], name: 'index_tickets_list_tickets_on_id', unique: true
  end

  add_foreign_key 'tickets_list_tickets', 'tickets_list_events', column: 'event_id'
end
