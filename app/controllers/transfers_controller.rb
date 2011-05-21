class TransfersController < ApplicationController
  respond_to :js
  
  def create
    @transfer = @current_shelter.transfers.new(params[:transfer])
    flash[:notice] = "Transfer has been created." if @transfer.save
  end
  
  def update
    @transfer = @current_shelter.transfers.find(params[:id])
    flash[:notice] = "Transfer has been approved." if @transfer.update_attributes(params[:transfer])
    respond_with(@transfer)
  end

  def destroy
    @transfer = @current_shelter.transfers.find(params[:id])
    @transfer.destroy
  end
  
  def approved
    @transfer = @current_shelter.transfers.find(params[:id])
    flash[:notice] = "Transfer has been approved." if @transfer.update_attributes({:approved => true})
    respond_with(@transfer)
  end
  
  def completed
    @transfer = @current_shelter.transfers.find(params[:id])
    flash[:notice] = "Transfer has been approved." if @transfer.update_attributes({:completed => true})
    respond_with(@transfer)
  end
  
end


