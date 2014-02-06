class Shared::SheltersController < ActionController::Base
  respond_to :json

  def auto_complete
    q = params[:q].strip
    @shelters = Shelter.active.auto_complete(q)
    render :json => @shelters.collect{ |shelter| {:id => shelter.id, :name => shelter.name, :lat => shelter.lat, :lng => shelter.lng } }.to_json
  end
end

