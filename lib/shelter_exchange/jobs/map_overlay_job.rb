module ShelterExchange
  module Jobs
    class MapOverlayJob

      def initialize
        @s3_filename  = "maps/overlay.kmz"
        @zip_filename = "overlay.kml"
      end

      def perform
        FOG_BUCKET.files.create(
          :key => @s3_filename,
          :body => build_kmz_file,
          :public => true,
          :content_type => Mime::KMZ,
          :cache_control => "max-age=315576000",
          :expires => 1.year.from_now.httpdate
        )
      end

      private

      def build_kmz_file
        Zippy.new(@zip_filename => MapsController.new.overlay).data
      end

    end
  end
end

