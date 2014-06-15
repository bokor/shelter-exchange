require "spec_helper"

# def perform
#   FOG_BUCKET.files.create(
#     :key => "maps/overlay-#{Time.now.to_i}.kmz",
#     :body => zip_kml_file,
#     :public => true,
#     :content_type => Mime::KMZ,
#     :cache_control => "max-age=315576000",
#     :expires => 1.year.from_now.httpdate
#   )
# end
#
# private
#
# def zip_kml_file
#   Zip::Archive.open_buffer(Zip::CREATE) do |archive|
#     archive.add_buffer("overlay.kml", MapsController.new.overlay);
#   end
# end

describe MapOverlayJob, ".perform" do

  it "creates file on s3" do
    Timecop.freeze(Time.parse("Mon, 12 May 2014"))
    allow(Zip::Archive).to receive(:open_buffer).with(Zip::CREATE).and_return("zip created")
    expect(FOG_BUCKET.files).to receive(:create).with({
      :key => "maps/overlay.kmz",
      :body => "zip created",
      :public => true,
      :content_type => Mime::KMZ,
      :cache_control=>"max-age=315576000",
      :expires => 1.year.from_now.httpdate
    })
    MapOverlayJob.new.perform
  end
end

