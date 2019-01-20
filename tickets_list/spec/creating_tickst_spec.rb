# frozen_string_literal: true

require 'spec_helper'

describe TicketsList, clean_db: true do
  subject { described_class.new }

  let(:event_id) { 'aaaaaaaa-a29f-46de-bbe1-f380cf96841a' }
  let(:ticket_id) { 'c07a2487-a29f-46de-bbe1-f380cf96841a' }

  describe 'with no tickets' do
    describe '#find' do
      it 'returns empty list' do
        expect(subject.find(ticket_id)).to eql(:not_found)
      end
    end

    describe '#find_for_event' do
      it 'returns empty list' do
        expect(subject.find_for_event(event_id)).to be_empty
      end
    end
  end

  describe 'with one bought ticket' do
    before :each do
      subject.handle_event(
        Events::DomainEvents::TicketSold.new(
          data: {
            event_id: event_id,
            ticket_id: ticket_id,
            places: 8
          }
        )
      )
    end

    describe '#find' do
      it 'returns ticket id' do
        expect(subject.find(ticket_id).id).to eql(ticket_id)
      end

      it 'returns event id' do
        expect(subject.find(ticket_id).event.id).to eql(event_id)
      end

      it 'returns places' do
        expect(subject.find(ticket_id).places).to eql(8)
      end
    end

    describe '#find_for_event' do
      it 'returns one event' do
        expect(subject.find_for_event(event_id).size).to eql(1)
      end

      it 'returns no events' do
        expect(subject.find_for_event('invalid-id').size).to eql(0)
      end
    end
  end
end
