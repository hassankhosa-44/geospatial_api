class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all
  end

  def show
    begin
      @ticket = Ticket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Ticket not found"
      redirect_to tickets_path
    end
  end
end
