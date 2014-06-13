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

  it "returns a no break space when date is blank" do
    expect(
      helper.days_left(nil)
    ).to eq("&nbsp;")
  end

  it "returns a no break space when greater than 2 weeks" do
    expect(
      helper.days_left(Time.zone.today + 15.days)
    ).to eq("&nbsp;")
  end

  it "returns 1 day left text singularized" do
    expect(
      helper.days_left(Time.zone.today + 1.day)
    ).to eq("<img alt=\"Icon_community_alert\" src=\"/assets/icon_community_alert.png\" /> 1 DAY LEFT")
  end

  it "returns number of days pluralized when between 2 and 14 days" do
    expect(
      helper.days_left(Time.zone.today + 5.days)
    ).to eq("<img alt=\"Icon_community_alert\" src=\"/assets/icon_community_alert.png\" /> 5 DAYS LEFT")
  end

  it "returns alert message days are 0 or less from today" do
    expect(
      helper.days_left(Time.zone.today)
    ).to eq("<img alt=\"Icon_community_alert\" src=\"/assets/icon_community_alert.png\" /> URGENT!")
  end
end
