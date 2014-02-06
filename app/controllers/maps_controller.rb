class MapsController < ApplicationController
  respond_to :kml
  layout false

  def overlay
    @shelters = Shelter.active.all
    render_to_string 'overlay', :format => :kml
  end
end

