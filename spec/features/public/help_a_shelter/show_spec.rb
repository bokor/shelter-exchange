require "rails_helper"

feature "Shelter's public profile" do

  background do
    switch_to_subdomain("www")
    logo = File.open(Rails.root.join("spec/data/images/photo.jpg"))
    @shelter = Shelter.gen(
        :name => "Cute Doggies",
        :street => "123 Main st.", :street_2 => "#101", :city => "Redwood city", :state => "CA", :zip_code => "94063",
        :phone => "999-999-9999", :fax => "999-999-9998", :email => "cute_doggies@example.org",
        :website => "http://shelterexchange.org", :facebook => "http://facebook.com/shelterexchange", :twitter => "@shelterexchange",
        :is_kill_shelter => false,
        :logo => logo
    )
  end

  scenario "shows shelter details" do
    visit public_help_a_shelter_path(@shelter)

    within "#shelter_details .logo" do
      logo = find("img")
      expect(logo[:src]).to eq("https://shelterexchange-test.s3.amazonaws.com/shelters/logos/#{@shelter.id}/thumb/#{@shelter.logo.filename}")
      expect(logo[:alt]).to eq("Cute Doggies Logo")
    end

    within "#shelter_details .social" do
      facebook = find(".facebook div")
      expect(facebook[:class]).to eq("fb-like")

      twitter = find(".twitter a")
      expect(twitter["data-via"]).to eq("shelterexchange")
      expect(twitter["data-related"]).to eq("shelterexchange")

      pinterest = find(".pinterest a")
      expect(pinterest[:href]).to eq(
        "//pinterest.com/pin/create/button/" +
        "?url=http://www.se.test:9292/help_a_shelter/#{@shelter.id}" +
        "&media=https://shelterexchange-test.s3.amazonaws.com/shelters/logos/#{@shelter.id}/original/#{@shelter.logo.filename}" +
        "&description=Help the Cute Doggies, located in Redwood city, CA, " +
        "by adopting an animal or donating items most needed at this shelter or rescue group.")
    end

    within "#shelter_details .address_info" do

      # Shelter Name
      expect(
        find("h2[itemprop='name']").text
      ).to eq("Cute Doggies")

      # Address Details
      expect(page).to have_selector("#address[itemprop='address'][itemtype='http://schema.org/PostalAddress']")
      expect(
        find("#address li[itemprop='streetAddress']").text
      ).to eq("123 Main st.")
      expect(
        find("span[itemprop='addressLocality']").text
      ).to eq("Redwood city")
      expect(
        find("span[itemprop='addressRegion']").text
      ).to eq("CA")
      expect(
        find("span[itemprop='postalCode']").text
      ).to eq("94063")

      # Contact Details
      expect(
        find("#contact_info span[itemprop='telephone']").text
      ).to eq("999-999-9999")
      expect(
        find_link("Email Us")[:href]
      ).to eq("mailto:cute_doggies@example.org?subject=From Shelter Exchange")
      expect(
        find_link("Visit Website")[:href]
      ).to eq("http://shelterexchange.org")
      expect(
        find_link("Get Directions")[:href]
      ).to eq("http://maps.google.com/maps?f=d&source=s_d&saddr=&daddr=123%20Main%20st.+%23101+Redwood%20city+CA+94063&hl=en")
      expect(
        find_link("Follow @shelterexchange")[:href]
      ).to eq("http://twitter.com/#!/shelterexchange")
      expect(
        find_link("Facebook Page")[:href]
      ).to eq("http://facebook.com/shelterexchange")
    end
  end

  scenario "list items in the wish list" do
    Item.gen(:name => "food", :shelter => @shelter)
    Item.gen(:name => "blankets", :shelter => @shelter)
    Item.gen(:name => "money", :shelter => @shelter)

    visit public_help_a_shelter_path(@shelter)

    within "#shelter_details .wish_list" do
      expect(all("ol#items li").count).to eq(3)
      expect(page).to have_content("food")
      expect(page).to have_content("blankets")
      expect(page).to have_content("money")
    end
  end

  scenario "no wish list available" do
    visit public_help_a_shelter_path(@shelter)

    within "#shelter_details .wish_list" do
      expect(page).to have_content("Shelter has not provided a wish list")
    end
  end

  scenario "access help text", :js => true do
    visit public_help_a_shelter_path(@shelter)

    expect(page).to have_selector("#help_text", :visible => false)

    within ".search_content" do
      click_link "?"
    end

    expect(page).to have_selector("#help_text", :visible => true)
  end

  xscenario "default list of animals available for adoption" do
    visit public_help_a_shelter_path(@shelter)
  end

  xscenario "filter animals available for adoption" do
    visit public_help_a_shelter_path(@shelter)
  end
end

