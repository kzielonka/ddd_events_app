# frozen_string_literal: true

class Events
  module ValueObjects
    class Description
      def initialize(description)
        @description = if description == :not_set
                         :not_set
                       else
                         String(description).strip.freeze
                       end
      end

      def to_s
        set? ? @description : ''
      end

      def set?
        @description != :not_set
      end

      def valid?(_draft = false)
        validate(true).empty?
      end

      def validate(draft = false)
        errors = []
        errors << 'is too long.' if to_s.size > 1000
        errors << "can't be empty." if to_s.empty? && !draft
        errors
      end
    end
  end
end
