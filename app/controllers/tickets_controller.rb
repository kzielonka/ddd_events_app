class TicketsController < ApplicationController
  def show
    @ticket = tickets_list.find(params[:id])
    head :not_found if @ticket == :not_found
  end

  private

  def tickets_list
    Rails.configuration.tickets_list
  end
end
