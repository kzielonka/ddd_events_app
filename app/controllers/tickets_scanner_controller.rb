# frozen_string_literal: true

class TicketsScannerController < ApplicationController
  def show
    @scanner = Scanner.new
  end

  def scan
    @scanner = Scanner.new(params.require(:tickets_scanner_controller_scanner).permit(:code))
    @show_valid_ticket_info = true
    @show_invalid_ticket_info = true
    @show_valid_but_already_scanned_info = true
    render :show
  end

  class Scanner
    include ActiveModel::Model

    attr_accessor :code
  end
  private_constant :Scanner
end
