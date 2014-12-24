require "rails_helper"

describe GoogleAnalyticsHelper, "#trackable_pageview" do

  it "returns the trackable path for public homepage" do
    allow(controller.request).to receive(:url).and_return("http://test.host/pages")

    expect(
      helper.trackable_pageview
    ).to eq("/")
  end

  it "returns the trackable path for a base path" do
    allow(controller.request).to receive(:url).and_return("http://test.host/save_a_life")

    expect(
      helper.trackable_pageview
    ).to eq("/save_a_life")
  end

  it "returns the trackable path when a route has an id" do
    allow(controller.request).to receive(:url).and_return("http://test.host/save_a_life/12345")

    expect(
      helper.trackable_pageview
    ).to eq("/save_a_life/{id}")
  end
end

