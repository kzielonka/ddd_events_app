# frozen_string_literal: true

Dir[File.join(File.dirname(__FILE__), 'value_objects', '*.rb')].each { |f| require f }

class Events
  module ValueObjects
  end
  private_constant :ValueObjects
end
