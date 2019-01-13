class Events
  module ValueObjects
    class Description
      def initialize(description)
        if description == :not_set
          @description = :not_set
        else
          @description = String(description).strip.freeze
        end
      end

      def to_s
        set? ? @description : ""
      end

      def set?
        @description != :not_set
      end

      def valid?(draft = false)
        validate(true).empty?
      end

      def validate(draft = false)
        errors = []
        errors << "is too long." if to_s.size > 1000
        errors << "can't be empty." if to_s.empty? && !draft
        errors
      end
    end
  end
end
