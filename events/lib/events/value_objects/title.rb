# frozen_string_literal: true

class Events
  module ValueObjects
    class Title
      def initialize(title)
        @title = if title == :not_set
                   :not_set
                 else
                   String(title).strip.freeze
                 end
      end

      def to_s
        set? ? @title : ''
      end

      def set?
        @title != :not_set
      end

      def valid?(_draft = false)
        validate(true).empty?
      end

      def validate(draft = false)
        errors = []
        errors << 'is too long.' if to_s.size > 100
        errors << "can't be empty." if to_s.empty? && !draft
        errors
      end
    end
  end
end
