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


      # <div class="address_info">
			# <h2 itemprop="name">Brian's Buddies</h2>

			# <ul itemprop="address" itemscope="" itemtype="http://schema.org/PostalAddress">
				# <li itemprop="streetAddress">730 Bair Island Rd  Apt 101</li>
				# <li>
					# <span itemprop="addressLocality">Redwood City</span>,
					# <span itemprop="addressRegion">CA</span>  <span itemprop="postalCode">94063</span>
				# </li>
			# </ul>
			# <br>
			# <ul>
				# <li>Phone: <span itemprop="telephone">999-999-9999</span></li>
				# <li class="action_links">
					# <span><a href="mailto:brian.bokor@shelterexchange.org?subject=From Shelter Exchange" itemprop="email">Email Us</a>|</span>
						# <span><a href="http://www.brianbokor.com" target="_blank">Visit Website</a>|</span>
					# <span class="get_directions_link">
						# <a href="http://maps.google.com/maps?f=d&amp;source=s_d&amp;saddr=&amp;daddr=730%20Bair%20Island%20Rd%20%20Apt%20101++Redwood%20City+CA+94063&amp;hl=en" target="_blank" itemprop="maps">Get Directions</a>
					# </span>
				# </li>
				# <li class="action_links">
						# <span><a href="http://twitter.com/#!/brianbokor" target="_blank">Follow @brianbokor</a>|</span>
						# <span><a href="http://www.facebook.com/brian.bokor" target="_blank">Facebook Page</a></span>
				# </li>
			# </ul>
		# </div>
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
    # visit public_help_a_shelter_path(@shelter)
  end

  xscenario "filter animals available for adoption" do
    # visit public_help_a_shelter_path(@shelter)
  end
end

