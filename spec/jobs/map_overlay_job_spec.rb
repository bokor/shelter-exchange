require "rails_helper"

describe MapOverlayJob, ".perform" do

  it "creates file on s3" do
    Timecop.freeze(Time.parse("Mon, 12 May 2014"))
    kmlbody = StringIO.new("zip created")
    allow(Zip::OutputStream).to receive(:write_buffer).and_return(kmlbody)
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

