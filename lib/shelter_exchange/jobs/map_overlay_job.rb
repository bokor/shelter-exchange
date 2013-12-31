module ShelterExchange
  module Jobs
    class MapOverlayJob

      def perform
        # write cache key(overlay-kmz-date) with date
        FOG_BUCKET.files.create(
          :key => "maps/overlay.kmz",
          :body => Zippy.new("overlay.kml" => MapsController.new.overlay).data,
          :public => true,
          :content_type => Mime::KMZ,
          :cache_control => "max-age=315576000",
          :expires => 1.year.from_now.httpdate
        )
      end

    end
  end
end

