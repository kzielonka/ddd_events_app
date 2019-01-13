class Events
  module ValueObjects
    class Title
      def initialize(title)
        if title == :not_set
          @title = :not_set
        else
          @title = String(title).strip.freeze
        end
      end

      def to_s
        set? ? @title : ""
      end

      def set?
        @title != :not_set
      end

      def valid?(draft = false)
        validate(true).empty?
      end

      def validate(draft = false)
        errors = []
        errors << "is too long." if to_s.size > 100
        errors << "can't be empty." if to_s.empty? && !draft
        errors
      end
    end
  end
end
