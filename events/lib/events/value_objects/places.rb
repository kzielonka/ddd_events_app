# frozen_string_literal: true

class Events
  module ValueObjects
    class Places
      def initialize(num)
        @num = if num == :not_set
                 :not_set
               else
                 Integer(num).dup.freeze
               end
      end

      def to_i
        set? ? @num : 0
      end

      def set?
        @num != :not_set
      end
    end
  end
end
