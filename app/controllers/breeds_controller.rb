class BreedsController < ApplicationController
  respond_to :json
   
  def auto_complete
    q = params[:q].strip
    # temp = params[:q].strip.split
    # q = temp.map {|str| str}.join("%")
    if params[:animal_type_id].blank?
      @breeds = Breed.where(["LOWER(name) LIKE LOWER(?)", "%#{q}%"])
    else
      @breeds = Breed.where(["animal_type_id = ? AND LOWER(name) LIKE LOWER(?)", params[:animal_type_id], "%#{q}%"])
    end  
    render :json => @breeds.collect{ |breed| {:id => "#{breed.id}", :label => "#{breed.name}", :value => "#{breed.name}", :name => "#{breed.name}", } }
  end

end