require "rails_helper"

feature "Update the Shelter Details" do
  login_user

  background do
    current_shelter.update_attributes({
      :name => "Shelter's Name",
      :phone => "9999999999",
      :fax => "1111111111",
      :email=> "email@shelterexchange.org"
    })
  end

  scenario "successfully save the changes" do
    visit edit_shelter_path(current_shelter)

    fill_in "Name", :with => "cuddle buddies"
    click_button "Update Shelter"

    expect(page.current_path).to eq shelters_path

    page_title_should_be "cuddle buddies"
    expect(find(".page_heading .action_links a")[:href]).to include(shelter_path(current_shelter))
  end

  context "when form invalid" do

    xscenario "errors are shown to the user" do
      # visit new_task_path

      # click_button "Create Task"

      # expect(page).to have_content "There was a problem with your submission."

      # within "#details_container" do
      #   expect(find(".error").text).to eq("Cannot be blank")
      # end

      # expect(current_path).to eq(tasks_path)
      # body_class_should_include "create_tasks"
    end
  end
end
