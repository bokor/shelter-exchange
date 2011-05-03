class MapsController < ApplicationController
  skip_before_filter :authenticate_user!, :current_account, :current_shelter, :set_shelter_timezone
  
  respond_to :kmz #:html, :js, :kml, :georss
  # cache_sweeper :map_sweeper
  
  def index
    @shelters = Shelter.all
    respond_with(@shelters) do |format|  
      # format.kml 
      format.kmz { 
        send_data(zip(render_to_string("index.kml"), "overlay.kml"), :type => :kmz)
      }
      # format.georss 
    end
  end
  
  private
    
    def zip(data, filename)
      Zippy.new(filename => data).data
      # zipfile = Rails.root.join("/tmp/map-overlay-#{rand 32768}")
      # Zip::ZipOutputStream::open(zipfile) do |io|
      #   io.put_next_entry(filename)
      #   io.write data
      # end
      # zippy = File.open(zipfile).read
      # File.delete(zipfile)
      # zippy
    end
    
end


# format.kmz { 
#    send_data(Zippy.new("maps.kmz" => render_to_string("index.kml")).data, :type => 'application/vnd.google-earth.kmz')
#    send_data(zip(render_to_string("index.kml"), "maps.kmz"), :type => 'application/vnd.google-earth.kmz')
#  }

# def zip(data, filename)
#   zipfile = Rails.root.join("/tmp/map-overlay-#{rand 32768}")
#   Zip::ZipOutputStream::open(zipfile) do |io|
#     io.put_next_entry(filename)
#     io.write data
#   end
#   zippy = File.open(zipfile).read
#   File.delete(zipfile)
#   zippy
#   
#   Zippy.new(filename => data).data
# end




