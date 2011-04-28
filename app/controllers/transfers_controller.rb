class TransfersController < ApplicationController
  respond_to :js
  
  def create
    @transfer = Transfer.new(params[:transfer])
    flash[:notice] = "Transfer has been created." if @transfer.save
  end
  
  def update
    @transfer = Transfer.find(params[:id])
    flash[:notice] = "Transfer has been approved." if @transfer.update_attributes({ :status => params[:status] })
    respond_with(@alert)
  end

  def destroy
    @transfer = Transfer.find(params[:id])
    @transfer.destroy
  end

end


