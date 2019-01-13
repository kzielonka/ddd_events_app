class Events
  module ValueObjects
    class NumberOfTickets
      def initialize(num)
        if num == :not_set
          @num = :not_set
        else
          @num = Integer(num).dup.freeze
        end
      end

      def to_i
        set? ? @num : 0
      end

      def set?
        @num != :not_set
      end

      def valid?
        validate.empty?
      end

      def validate
        errors = []
        errors << "Number of tickets can not be less than 0" if to_i < 0
        errors << "Number of tickets can not be greater than 1000000" if to_i > 1000000
        errors
      end
    end
  end
end
