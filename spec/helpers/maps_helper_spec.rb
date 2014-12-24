require "rails_helper"

describe MapsHelper, "#map_shelter_icon" do

  it "returns image with asset_host name" do
    allow(Rails.application.config.action_controller).to receive(:asset_host).and_return("test.host")
    expect(
      helper.map_shelter_icon
    ).to eq("http://test.host/assets/logo_xsmall.png")
  end

  it "returns default image path" do
    allow(Rails.application.config.action_controller).to receive(:asset_host).and_return(nil)
    expect(
      helper.map_shelter_icon
    ).to eq("/assets/logo_xsmall.png")
  end
end

describe MapsHelper, "#shelter_info_window" do

  before do
    @shelter = Shelter.gen \
      :name => "HTML TEST",
      :street => "123 Main St.", :street_2 => "Apt 101",
      :city => "LALA Town", :state => "CA", :zip_code => "90210",
      :phone => "999-111-1234",
      :email => nil,
      :website => nil

    allow(
      Rails.application.routes.url_helpers
    ).to receive(:public_help_a_shelter_url).and_return("http://www.test.host/help_a_shelter")
  end

  it "returns info window html without email and website" do
    html = "<h2><a href='http://www.test.host/help_a_shelter'>HTML TEST</a></h2>" +
           "<ul>" +
           "<li>123 Main St.</li>" +
           "<li>Apt 101</li>" +
           "<li>LALA Town, CA 90210</li>" +
           "<li style='padding-bottom: 10px;'>999-111-1234</li>" +
           "</ul>"
    expect(
      helper.shelter_info_window(@shelter)
    ).to eq(html)
  end

  it "returns info window html with email and website" do
    @shelter.update_attributes({
      :email => "html.test@test.host",
      :website => "http://www.html.test.host"
    })

    html = "<h2><a href='http://www.test.host/help_a_shelter'>HTML TEST</a></h2>" +
           "<ul>" +
           "<li>123 Main St.</li>" +
           "<li>Apt 101</li>" +
           "<li>LALA Town, CA 90210</li>" +
           "<li style='padding-bottom: 10px;'>999-111-1234</li>" +
           "<li><strong style='padding:0 5px 0 0;'><a href='mailto:html.test@test.host'>Email us</a></strong>" +
           "|" +
           "<strong style='padding:0 0 0 5px;'><a href='http://www.html.test.host' target='_blank'>Visit Website</a></strong>" +
           "</li></ul>"
    expect(
      helper.shelter_info_window(@shelter)
    ).to eq(html)
  end

  it "returns info window html with logo" do
    @shelter.update_attributes({
      :logo => File.open(Rails.root.join("spec/data/images/photo.jpg"))
    })

    html = "<h2><a href='http://www.test.host/help_a_shelter'>HTML TEST</a></h2>" +
           "<ul>" +
           "<li>123 Main St.</li>" +
           "<li>Apt 101</li>" +
           "<li>LALA Town, CA 90210</li>" +
           "<li style='padding-bottom: 10px;'>999-111-1234</li>" +
           "</ul>" +
           "<div style='width:100%; text-align:center; margin: 0 auto;'>" +
           "<img src='#{@shelter.logo.url(:thumb)}' alt='' />" +
           "</div>"
    expect(
      helper.shelter_info_window(@shelter)
    ).to eq(html)
  end
end

