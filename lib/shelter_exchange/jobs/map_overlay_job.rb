module ShelterExchange
  module Jobs
    class MapOverlayJob

      def perform
        # Add Date to publish date if you can do a fuzzy search for a name (like overlay-9879008.kml) and search for overlay)

        FOG_BUCKET.files.create(
          :key => "maps/overlay.kmz",
          :body => build_kmz_file,
          :public => true,
          :content_type => Mime::KMZ,
          :cache_control => "max-age=315576000",
          :expires => 1.year.from_now.httpdate
        )
      end

      private
      def build_kmz_file
        Zippy.new("overlay.kml" => MapsController.new.overlay).data
      end

    end
  end
end

