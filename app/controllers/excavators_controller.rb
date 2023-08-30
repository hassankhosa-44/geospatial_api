class ExcavatorsController < ApplicationController
  def index
    @excavators = Excavator.all
  end

  def show
    begin
      @excavator = Excavator.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Excavator not found"
      redirect_to excavators_path
    end
  end
end
