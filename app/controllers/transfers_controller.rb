class TransfersController < ApplicationController
  respond_to :js
  
  def create
    @transfer = @current_shelter.transfers.new(params[:transfer])
    flash[:notice] = "Transfer has been created." if @transfer.save
  end
  
  def edit
    @transfer = @current_shelter.transfers.find(params[:id])
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
  
  # def approve
  #   @transfer = @current_shelter.transfers.find(params[:id])
  #   flash[:notice] = "Transfer has been Approved." if @transfer.update_attributes({:status => "approved"})
  #   respond_with(@transfer)
  # end
  # 
  # def reject
  #   @transfer = @current_shelter.transfers.find(params[:id])
  #   flash[:notice] = "Transfer has been Rejected." if @transfer.update_attributes({:status => "rejected"})
  #   respond_with(@transfer)
  # end
  # 
  # def complete
  #   @transfer = @current_shelter.transfers.find(params[:id])
  #   flash[:notice] = "Transfer has been Completed." if @transfer.update_attributes({:status => "completed"})
  #   respond_with(@transfer)
  # end
  
end


