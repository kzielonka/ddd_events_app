require "spec_helper"

describe "creating event" do
  subject { Events.new(event_store) }

  let(:event_store) { EventStoreFake.new }

  let(:event_id) { "c07a2487-a29f-46de-bbe1-f380cf96841a" }

  it "published EventCreated event" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    expect(event_store.all_events.map(&:data)).to eql([
      { id: event_id }
    ])
  end

  it "raises error if event has already been created" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    expect do
      subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    end.to raise_exception(Events::Errors::EventAlreadyCreated)
  end

  it "updates event data" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    subject.execute_command(
      Events::Commands::UpdateEventDetails.new(
        event_id:    event_id,
        title:       "Title",
        description: "Description",
        number_of_tickets: 5,
      ),
    )
    expect(event_store.all_events.map(&:data)).to eql([
      { id: event_id },
      { id: event_id, title: "Title" },
      { id: event_id, description: "Description" },
      { id: event_id, number_of_tickets: 5 },
    ])
  end

  it "updates number of tickets" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    subject.execute_command(
      Events::Commands::UpdateEventDetails.new(
        event_id:          event_id,
        title:             "Title",
        description:       "Description",
        number_of_tickets: 10,
      ),
    )
    expect(event_store.all_events.map(&:data)).to eql([
      { id: event_id },
      { id: event_id, title: "Title" },
      { id: event_id, description: "Description" },
      { id: event_id, number_of_tickets: 10 },
    ])
  end

  it "raises error trying update not created event" do
    expect do
      subject.execute_command(
        Events::Commands::UpdateEventDetails.new(
          event_id:    event_id,
          title:       "Title",
          description: "Description",
          number_of_tickets: 5,
        ),
      )
    end.to raise_exception(Events::Errors::EventNotFound)
  end

  it "raises error when title is too long" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    expect do
      subject.execute_command(
        Events::Commands::UpdateEventDetails.new(
          event_id:    event_id,
          title:       "x" * 101,
          description: "Description",
          number_of_tickets: 5,
        ),
      )
    end.to raise_exception(Events::Errors::InvalidEventDetails)
  end

  it "raises error updating published event" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    subject.execute_command(
      Events::Commands::UpdateEventDetails.new(
        event_id:    event_id,
        title:       "Title",
        description: "Description",
        number_of_tickets: 5,
      ),
    )
    subject.execute_command(Events::Commands::PublishEvent.new(event_id: event_id))
    expect do
      subject.execute_command(
        Events::Commands::UpdateEventDetails.new(
          event_id:    event_id,
          title:       "Title",
          description: "Description",
          number_of_tickets: 5,
        ),
      )
    end.to raise_exception(Events::Errors::PublishedEventCantBeUpdated)
  end

  it "raises error when number of tickets is below 0" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    expect do
      subject.execute_command(
        Events::Commands::UpdateEventDetails.new(
          event_id:          event_id,
          title:             "Title",
          number_of_tickets: -2,
          description:       "Description",
        ),
      )
    end.to raise_exception(Events::Errors::InvalidEventDetails)
  end

  it "raises error when number of tickets is too huge" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    expect do
      subject.execute_command(
        Events::Commands::UpdateEventDetails.new(
          event_id:          event_id,
          title:             "Title",
          number_of_tickets: 1_000_001,
          description:       "Description",
        ),
      )
    end.to raise_exception(Events::Errors::InvalidEventDetails)
  end

  it "publishes event" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    subject.execute_command(
      Events::Commands::UpdateEventDetails.new(
        event_id:    event_id,
        title:       "Title",
        description: "Description",
        number_of_tickets: 10,
      ),
    )
    subject.execute_command(Events::Commands::PublishEvent.new(event_id: event_id))
    expect(event_store.all_events.map(&:data)).to eql([
      { id: event_id },
      { id: event_id, title: "Title" },
      { id: event_id, description: "Description" },
      { id: event_id, number_of_tickets: 10 },
      { id: event_id },
    ])
  end

  it "raises error trying to publish error with empty title" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    subject.execute_command(
      Events::Commands::UpdateEventDetails.new(
        event_id:    event_id,
        title:       "",
        description: "Description",
        number_of_tickets: 10,
      ),
    )
    expect do
      subject.execute_command(Events::Commands::PublishEvent.new(event_id: event_id))
    end.to raise_exception(Events::Errors::InvalidEventDetails)
  end

  it "raises error trying to publish error with empty description" do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
    subject.execute_command(
      Events::Commands::UpdateEventDetails.new(
        event_id:    event_id,
        title:       "Title",
        description: "",
        number_of_tickets: 10,
      ),
    )
    expect do
      subject.execute_command(Events::Commands::PublishEvent.new(event_id: event_id))
    end.to raise_exception(Events::Errors::InvalidEventDetails)
  end
end
