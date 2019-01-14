class EventsList
  Event = Struct.new(:id, :title, :description, :total_number_of_tickets, :published) do
    def published?
      published
    end
  end
  private_constant :Event
end
