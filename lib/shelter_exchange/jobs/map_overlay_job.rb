module ShelterExchange
  module Jobs
    class MapOverlayJob

      def perform
        # write cache key(overlay-kmz-date) with date
        FOG_BUCKET.files.create(
          :key => "maps/overlay.kmz",
          :body => zip_archive_data,
          :public => true,
          :content_type => Mime::KMZ,
          :cache_control => "max-age=315576000",
          :expires => 1.year.from_now.httpdate
        )
      end

      private

      def zip_archive_data
        Zip::Archive.open_buffer(Zip::CREATE) do |archive|
          archive.add_buffer("overlay.kml", MapsController.new.overlay);
        end
      end

    end
  end
end

