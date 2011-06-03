class TransfersController < ApplicationController
  respond_to :js
  
  def create
    @transfer = @current_shelter.transfers.new(params[:transfer])
    flash[:notice] = "Transfer has been created." if @transfer.save
  end
  
  def edit
    @transfer = @current_shelter.transfers.includes(:animal).find(params[:id])
    @transfer.status = params[:status] unless params[:status].blank?
    respond_with(@transfer)
  end
  
  def update
    @transfer = @current_shelter.transfers.find(params[:id])
    flash[:notice] = "Transfer has been #{params[:transfer][:status]}." if @transfer.update_attributes(params[:transfer])
    respond_with(@transfer)
  end

  def destroy
    @transfer = @current_shelter.transfers.find(params[:id])
    @transfer.destroy
  end
  
end


