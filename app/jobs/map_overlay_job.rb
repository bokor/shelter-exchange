class MapOverlayJob

  def perform
    FOG_BUCKET.files.create(
      :key => "maps/overlay.kmz",
      :body => zip_kml_file,
      :public => true,
      :content_type => Mime::KMZ,
      :cache_control => "max-age=315576000",
      :expires => 1.year.from_now.httpdate
    )
  end

  private

  def zip_kml_file
    stringio = Zip::OutputStream.write_buffer do |zio|
      zio.put_next_entry('overlay.kml')
      zio.write(MapsController.new.overlay)
    end

    stringio.rewind
    stringio.sysread
  end
end

