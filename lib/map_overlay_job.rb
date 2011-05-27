class MapOverlayJob
  
  def initialize
    @s3_filename ||= "maps/overlay.kmz"
    @zip_filename ||= "overlay.kml"
  end
  
  def perform
    AWS::S3::S3Object.store(@s3_filename, 
                            build_kmz_file, 
                            S3_BUCKET, 
                            :access => S3_ACL, 
                            :content_type => Mime::KMZ)
  end
  
  private
    def build_kmz_file
      Zippy.new(@zip_filename => MapsController.new.overlay).data
    end
    
end





