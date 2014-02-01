class MapsController < ApplicationController
  layout false

  def overlay
    @shelters = Shelter.active.all
    render_to_string 'overlay', :format => :kml
  end
end

