class StatusHistoriesController < ApplicationController
  respond_to :js

  def edit
    @status_history = @current_shelter.status_histories.find(params[:id])
  end

  def update
    @status_history = @current_shelter.status_histories.find(params[:id])
    flash[:notice] = "Status history has been updated." if @status_history.update_attributes(params[:status_history])
  end

  def destroy
    @status_history = @current_shelter.status_histories.find(params[:id])
    @status_history.destroy
  end
end

