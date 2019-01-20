# frozen_string_literal: true

require 'tickets_list'

require 'active_record'
require 'database_cleaner'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  hostname: ENV['DATABASE_HOST'] || 'localhost',
  database: ENV['DATABASE_NAME_TEST'] || 'ddd_events_app_test',
  username: ENV['DATABASE_USERNAME'],
  password: ENV['DATABASE_PASSWORD']
)

RSpec.configure do |config|
  config.before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    if example.metadata[:clean_db]
      DatabaseCleaner.cleaning do
        example.run
      end
    else
      example.run
    end
  end
end
