require "spec_helper"

describe AlertsHelper, "#show_alertable_link" do

  it "returns no link" do
    alert = Alert.gen
    expect(
      helper.show_alertable_link(alert)
    ).to be_nil
  end

  it "returns a link for an alertable" do
    allow(controller).to receive(:controller_name).and_return("alerts")

    animal = Animal.gen
    alert = Alert.gen :alertable => animal

    expect(
      helper.show_alertable_link(alert)
    ).to eq("<span class='alertable_link'>(<a href=\"#{animal_path(animal)}\">#{animal.name}</a>)</span>")
  end
end


