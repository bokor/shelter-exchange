class Shared::BreedsController < ActionController::Base
  respond_to :json

  def auto_complete
    json = [{}]

    unless params[:animal_type_id].blank?
      q = params[:q].strip
      @breeds = Breed.auto_complete(params[:animal_type_id], q).all
      json = @breeds.collect{ |breed| {:id => breed.id, :name => breed.name }}
    end

    render :json => json.to_json
  end
end

