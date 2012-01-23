class Public::SheltersController < Public::ApplicationController
  respond_to :json
   
  def auto_complete
    q = params[:q].strip
    @shelters = Shelter.auto_complete(q).all
    render :json => @shelters.collect{ |shelter| {:id => shelter.id, :name => "#{shelter.name}", :lat => "#{shelter.lat}", :lng => "#{shelter.lng}" } }.to_json
  end

end