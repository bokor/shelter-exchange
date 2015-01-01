require "rails_helper"

describe UrlHelper, "#with_subdomain" do

  it "returns a host with a subdomain" do
    subdomain = "doggie-center"

    expect(
      helper.with_subdomain(subdomain)
    ).to eq("doggie-center.se.test")
  end

  it "returns a host without a subdomain" do
    subdomain = ""

    expect(
      helper.with_subdomain(subdomain)
    ).to eq("se.test")
  end
end

describe UrlHelper, "#url_for" do

  it "returns url with a subdomain" do
    options = { :subdomain => "doggies-and-kitties" }

    expect(
      helper.url_for(options)
    ).to eq("http://doggies-and-kitties.se.test/login")
  end

  it "returns default url path" do
    expect(
      helper.url_for
    ).to eq("/login")
  end
end

describe UrlHelper, "#full_url" do

  it "returns a full url without default port" do
   allow(controller.request).to receive(:protocol).and_return("http://")
   allow(controller.request).to receive(:port).and_return(80)
   allow(controller.request).to receive(:host).and_return("doggies.test.host")

    expect(
      helper.full_url
    ).to eq("http://doggies.test.host")
  end

  it "returns a full url with specific port" do
   allow(controller.request).to receive(:protocol).and_return("https://")
   allow(controller.request).to receive(:port).and_return(1234)
   allow(controller.request).to receive(:host).and_return("doggies.test.host")

    expect(
      helper.full_url
    ).to eq("https://doggies.test.host:1234")
  end
end

describe UrlHelper, "#map_overlay_url" do

  it "returns the map overlay url with last modified" do
    last_modified = OpenStruct.new({ :last_modified => 12345 })
    allow_any_instance_of(Fog::Storage::AWS::Files).to receive(:head).and_return(last_modified)

    expect(
      helper.map_overlay_url
    ).to eq("https://shelterexchange-test.s3.amazonaws.com/maps/overlay.kmz?12345")
  end
end

