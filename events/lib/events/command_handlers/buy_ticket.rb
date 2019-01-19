class Events
  class CommandHandlers
    class BuyTicket < Handler
      def handle(command)
        return unless command.is_a?(Commands::BuyTicket)

        with_event(command.event_id) do |event|
          event.buy_ticket(command.ticket_id, command.places)
        end
      end
    end
  end
end
