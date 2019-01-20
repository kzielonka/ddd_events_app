# frozen_string_literal: true

require 'spec_helper'

describe 'buying tickets' do
  subject { Events.new(event_store, uuid_generator) }

  let(:uuid_generator) { instance_double('uuid generator', call: ticket_id) }

  let(:event_store) { EventStoreFake.new }

  let(:event_id) { 'c07a2487-a29f-46de-bbe1-f380cf96841a' }
  let(:ticket_id) { 'aaaaaaaa-a29f-46de-bbe1-f380cf96841a' }

  before :each do
    subject.execute_command(Events::Commands::CreateEvent.new(id: event_id))
  end

  context 'not published event' do
    it 'raises error that event is not published' do
      expect do
        subject.execute_command(
          Events::Commands::BuyTicket.new(
            event_id: event_id,
            ticket_id: ticket_id,
            places: 2
          )
        )
      end.to raise_exception Events::Errors::EventIsNotPublic
    end
  end

  context 'published event' do
    before :each do
      subject.execute_command(
        Events::Commands::UpdateEventDetails.new(
          event_id: event_id,
          title: 'Title',
          description: 'Description',
          total_places: 10
        )
      )
      subject.execute_command(Events::Commands::PublishEvent.new(event_id: event_id))
    end

    it 'rasies error that number of places must be greater than 0' do
      expect do
        subject.execute_command(
          Events::Commands::BuyTicket.new(
            event_id: event_id,
            ticket_id: ticket_id,
            places: 0
          )
        )
      end.to raise_exception Events::Errors::PlacesMustBeNonZeroPositive
    end

    it 'raises error that there is not enough tickets' do
      expect do
        subject.execute_command(
          Events::Commands::BuyTicket.new(
            event_id: event_id,
            ticket_id: ticket_id,
            places: 11
          )
        )
      end.to raise_exception Events::Errors::NotEnoughTickets
    end

    it 'raises error that there is not enough tickets if some are sold' do
      subject.execute_command(
        Events::Commands::BuyTicket.new(
          event_id: event_id,
          ticket_id: ticket_id,
          places: 10
        )
      )
      expect do
        subject.execute_command(
          Events::Commands::BuyTicket.new(
            event_id: event_id,
            ticket_id: ticket_id,
            places: 2
          )
        )
      end.to raise_exception Events::Errors::NotEnoughTickets
    end

    it 'publishes event that ticket has been sold' do
      subject.execute_command(
        Events::Commands::BuyTicket.new(
          event_id: event_id,
          ticket_id: ticket_id,
          places: 2
        )
      )
      expect(event_store).to have_event(
        Events::DomainEvents::TicketSold.new(
          data: {
            event_id: event_id,
            ticket_id: ticket_id,
            places: 2
          }
        )
      )
    end

    it 'publishes event that free places has changed' do
      subject.execute_command(
        Events::Commands::BuyTicket.new(
          event_id: event_id,
          ticket_id: ticket_id,
          places: 2
        )
      )
      expect(event_store).to have_event(
        Events::DomainEvents::EventFreePlacesChanged.new(
          data: {
            id: event_id,
            free_places: 8
          }
        )
      )
    end
  end
end
