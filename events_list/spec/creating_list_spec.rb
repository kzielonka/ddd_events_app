require 'spec_helper'

describe EventsList, clean_db: true do
  subject { described_class.new }

  let(:event_id) { "c07a2487-a29f-46de-bbe1-f380cf96841a" }

  describe 'with no events' do
    describe '#all_events' do
      it 'returns empty list' do
        expect(subject.all_events).to be_empty
      end
    end

    describe '#published_events' do
      it 'returns empty list' do
        expect(subject.all_events).to be_empty
      end
    end
  end

  describe 'with one not published event with only title' do
    before :each do
      subject.handle_event(Events::DomainEvents::EventTitleUpdated.new(data: { id: event_id, title: 'Title' }))
    end

    describe '#all_events' do
      it 'returns one event' do
        expect(subject.all_events.size).to eql(1)
      end

      it 'returns event with title' do
        expect(subject.all_events.first.title).to eql('Title')
      end

      it 'returns event with blank description' do
        expect(subject.all_events.first.description).to eql('')
      end

      it 'returns not published event' do
        expect(subject.all_events.first.published?).to be(false)
      end
    end
  end

  describe 'with one published event with full data' do
    before :each do
      subject.handle_event(Events::DomainEvents::EventTitleUpdated.new(data: { id: event_id, title: 'Title' }))
      subject.handle_event(Events::DomainEvents::EventDescriptionUpdated.new(data: { id: event_id, description: 'Description' }))
      subject.handle_event(Events::DomainEvents::EventNumberOfTicketsUpdated.new(data: { id: event_id, number_of_tickets: 5 }))
      subject.handle_event(Events::DomainEvents::EventPublished.new(data: { id: event_id }))
    end

    describe '#all_events' do
      it 'returns one event' do
        expect(subject.all_events.size).to eql(1)
      end

      it 'returns event with title' do
        expect(subject.all_events.first.title).to eql('Title')
      end

      it 'returns event with blank description' do
        expect(subject.all_events.first.description).to eql('Description')
      end

      it 'returns not published event' do
        expect(subject.all_events.first.published?).to be(true)
      end
    end
  end
end
