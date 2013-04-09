class TransfersController < ApplicationController
  respond_to :js

  def create
    @transfer = Transfer.new(params[:transfer])
    flash[:notice] = "Transfer has been created." if @transfer.save
  end

  def edit
    @transfer = Transfer.includes(:animal).find(params[:id])
    @transfer.status = params[:status] unless params[:status].blank?
    respond_with(@transfer)
  end

  def update
    @transfer = Transfer.find(params[:id])
    flash[:notice] = "Transfer has been #{params[:transfer][:status]}." if @transfer.update_attributes(params[:transfer])
    respond_with(@transfer)
  end

  def destroy
    @transfer = Transfer.find(params[:id])
    @transfer.destroy
  end

end


