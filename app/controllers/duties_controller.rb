class DutiesController < ApplicationController
  private

  def duties_params
    params.require(:duty).permit(:name, :repeat, :start_date, :end_date, :urgency, :display_in, :send_reminder, :created_by)
  end  
end
