require "rails_helper"

describe Public::ApplicationHelper, "#page_name" do

  it "returns action_name and controller_name class name text" do
    allow(controller).to receive(:controller_name).and_return("animals")
    allow(controller).to receive(:action_name).and_return("new")

    expect(
      helper.page_name
    ).to eq("new_animals")
  end

  it "returns home_page class name text" do
    allow(controller).to receive(:controller_name).and_return("pages")
    allow(helper.request).to receive(:path).and_return("/")

    expect(
      helper.page_name
    ).to eq("home_page")
  end

  it "returns path name and pages class name text" do
    allow(controller).to receive(:controller_name).and_return("pages")
    allow(helper.request).to receive(:path).and_return("/help_a_shelter/find_animals")

    expect(
      helper.page_name
    ).to eq("help_a_shelter_find_animals_page")
  end
end

