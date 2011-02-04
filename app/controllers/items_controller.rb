class ItemsController < ApplicationController
  # before_filter :authenticate_user!
  # respond_to :js
  # 
  # def edit
  #   @item = @current_shelter.items.find(params[:id])
  # end
  # 
  # def update
  #   @item = @current_shelter.items.find(params[:id])
  #   flash[:notice] = "#{@item.name} has been updated." if @item.update_attributes(params[:item])
  # end
  # 
  # def create
  #   @itemable = find_polymorphic_class
  #   @item = @current_shelter.items.new(params[:item].merge(:itemable => @itemable))
  #   flash[:notice] = "#{@item.name} has been created." if  @item.save
  # end
  # 
  # def destroy
  #   @item = @current_shelter.items.find(params[:id])
  #   @item.destroy
  # end

end
