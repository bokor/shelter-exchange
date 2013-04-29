class Shared::BreedsController < ActionController::Base
  respond_to :json

  def auto_complete
    return if params[:animal_type_id].blank?
    q = params[:q].strip
    @breeds = Breed.auto_complete(params[:animal_type_id], q).all
    render :json => @breeds.collect{ |breed| {:id => breed.id, :name => "#{breed.name}" }}.to_json
  end
end

