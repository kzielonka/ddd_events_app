class Events
  module ValueObjects
    class Places
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
    end
  end
end
