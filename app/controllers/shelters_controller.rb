class SheltersController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js
  
  def index
    @shelter = @current_shelter
    respond_with(@shelter)
  end
  
  def show
    redirect_to shelters_path and return
  end
  
  def edit
    @shelter = @current_shelter
    5.times { @shelter.items.build } if @shelter.items.blank?
    # (5 - @shelter.items.size).times { |i| @shelter.items.build }
    respond_with(@shelter)
  end
  
  def new
    # 5.times { @shelter.items.build }
    redirect_to shelters_path and return
  end
  
  def create
    redirect_to shelters_path and return
  end
  
  def update
    @shelter = @current_shelter    
    respond_with(@shelter) do |format|
      if @shelter.update_attributes(params[:shelter])  
        flash[:notice] = "#{@shelter.name} has been updated."
        format.html { redirect_to shelters_path }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
  def destroy
    redirect_to shelters_path and return
  end
  
end
