class MapOverlayJob
  
  def initialize
    @s3_bucket ||= S3_CREDENTIALS[Rails.env]["bucket"] 
    @s3_access ||= S3_CREDENTIALS[Rails.env]["acl"]
    @s3_filename ||= "maps/overlay.kmz"
    @zip_filename ||= "overlay.kml"
  end
  
  def perform
    AWS::S3::S3Object.store(@s3_filename, 
                            build_kmz_file, 
                            @s3_bucket, 
                            :access => @s3_access, 
                            :content_type => Mime::KMZ)
  end
  
  private
    def build_kmz_file
      Zippy.new(@zip_filename => MapsController.new.overlay).data
    end
    
end




