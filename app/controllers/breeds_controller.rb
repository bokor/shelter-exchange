class BreedsController < ApplicationController
  # load_and_authorize_resource
  respond_to :json
   
  def auto_complete
    q = params[:q].strip
    flash[:error] = "Animal Type not specified" and return if params[:animal_type_id].blank?
    @breeds = Breed.auto_complete(params[:animal_type_id], q)
    render :json => @breeds.collect{ |breed| {:id => "#{breed.id}", :label => "#{breed.name}", :value => "#{breed.name}", :name => "#{breed.name}" } }
  end

end

# temp = params[:q].strip.split
# q = temp.map {|str| str}.join("%")