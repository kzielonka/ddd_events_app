class EventsList
  Event = Struct.new(:id, :title, :description, :total_places, :free_places, :published) do
    def published?
      published
    end
  end
  private_constant :Event
end
