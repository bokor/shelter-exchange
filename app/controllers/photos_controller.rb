class PhotosController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js
  
  def destroy
    @animal = @current_shelter.animals.find(params[:id])
    @animal.photo.clear 
    @animal.save
  end
  
end
