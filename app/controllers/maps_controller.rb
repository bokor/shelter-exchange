class MapsController < ApplicationController
  
  def overlay
    @shelters = Shelter.all
    return render_to_string("overlay.kml")
  end

end


# class MapsController < AbstractController::Base
#   include AbstractController::Rendering
#   include AbstractController::Layouts
#   include AbstractController::Helpers
#   include AbstractController::Translation
#   include AbstractController::AssetPaths
#   include Rails.application.routes.url_helpers
#   
#   helper MapsHelper
#   
#   self.view_paths = "app/views"
#   
#   def overlay
#     @shelters = Shelter.all
#     return render_to_string("overlay.kml")
#   end
# 
# end
