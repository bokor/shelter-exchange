require "spec_helper"

describe CommunitiesHelper, "#get_directions_address" do

  it "returns a url concat of the shelters address" do
    shelter = Shelter.gen \
      :street => "1234 Main St",
      :street_2 => "Apt n/a",
      :city => "LALA Land",
      :state => "CA",
      :zip_code => "90210"

    expect(
      helper.get_directions_address(shelter)
    ).to eq("1234%20Main%20St+Apt%20n/a+LALA%20Land+CA+90210")
  end
end

describe CommunitiesHelper, "#days_left" do

  it "returns a no break space when greater than 2 weeks" do
    expect(
      helper.days_left(Time.zone.today, Time.zone.today - 2.weeks - 1.day)
    ).to eq("&nbsp;")
  end

  it "returns alert message when 2 weeks or less time left" do
    expect(
      helper.days_left(Time.zone.today, Time.zone.today - 2.weeks)
    ).to eq("<img alt=\"Icon_community_alert\" src=\"/assets/icon_community_alert.png\" /> URGENT!")
  end
end
