class Admin::AnimalsController < Admin::ApplicationController
  respond_to :html, :js

  def index
  end

  def lookup
    @animals = Animal.includes(:shelter, :photos).find(params[:id])
    render :index
  end
end
