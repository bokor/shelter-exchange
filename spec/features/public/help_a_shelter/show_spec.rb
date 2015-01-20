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
        :is_kill_shelter => true,
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
      items = all("ol#items li")
      expect(items.count).to eq(3)
      expect(items[0].text).to eq("food")
      expect(items[1].text).to eq("blankets")
      expect(items[2].text).to eq("money")
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

  context "with animals" do

    background do
      dog = AnimalType.gen(:id => 1, :name => "Dog")
      cat = AnimalType.gen(:id => 2, :name => "Cat")
      @animal1 = Animal.gen(
        :name => "Jimmy", :animal_type => dog, :animal_status_id => 1,
        :primary_breed => "Labrador Retriever", :secondary_breed => "Golden Retriever", :sex => "male",
        :is_mix_breed => true, :is_sterilized => false, :shelter => @shelter,
        :euthanasia_date_year => 5.days.ago.strftime("%Y"), :euthanasia_date_month => 5.days.ago.strftime("%m"), :euthanasia_date_day => 5.days.ago.strftime("%d")
      )
      @animal2 = Animal.gen(
        :name => "Billy", :animal_type => dog, :animal_status_id => 1,
        :primary_breed => "Golden Retriever", :sex => "male",
        :is_mix_breed => false, :is_sterilized => true, :shelter => @shelter
      )
      @animal3 = Animal.gen(
        :name => "Abbey", :animal_type => dog, :animal_status_id => 1,
        :primary_breed => "Cutie", :sex => "female",
        :is_mix_breed => true, :is_sterilized => false, :shelter => @shelter
      )
      @animal4 = Animal.gen(
        :name => "Ruby", :animal_type => cat, :animal_status_id => 1,
        :primary_breed => "Tabby", :sex => "female",
        :is_mix_breed => false, :is_sterilized => false, :shelter => @shelter
      )

      @photo = Photo.gen :image => File.open(Rails.root.join("spec/data/images/photo.jpg")), :attachable => @animal1
    end

    scenario "default animal list is sorted by name", :js => true do
      visit public_help_a_shelter_path(@shelter)

      within "#animals" do
        animals = all(".animal")
        expect(animals.count).to eq(4)
        expect(animals[0][:id]).to eq("#{dom_id(@animal3)}")
        expect(animals[1][:id]).to eq("#{dom_id(@animal2)}")
        expect(animals[2][:id]).to eq("#{dom_id(@animal1)}")
        expect(animals[3][:id]).to eq("#{dom_id(@animal4)}")
      end
    end

    scenario "default animal list shows correct content", :js => true do
      visit public_help_a_shelter_path(@shelter)

      within "##{dom_id(@animal1)}" do
        expect(find("h3").text).to have_content("Jimmy")

        photo = find(".photo img")
        expect(photo[:src]).to eq("https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@animal1.id}/small/#{@photo.image.filename}")
        expect(photo[:alt]).to eq("Jimmy - Labrador Retriever & Golden Retriever Mix")

        expect(find("ul li:nth-child(1)").text).to eq("Dog: Male")
        expect(find("ul li:nth-child(2)").text).to eq("Labrador Retriever & Golden Retriever Mix")
        expect(find("ul li.euthanisia_date").text).to eq("URGENT!")
      end

      within "##{dom_id(@animal2)}" do
        expect(find("h3").text).to have_content("Billy")

        photo = find(".photo img")
        expect(photo[:src]).to eq("http://www.se.test:9292/assets/default_small_photo.jpg")
        expect(photo[:alt]).to eq("Billy - Golden Retriever")

        expect(find("ul li:nth-child(1)").text).to eq("Dog: Male (Sterilized)")
        expect(find("ul li:nth-child(2)").text).to eq("Golden Retriever")
      end

      within "##{dom_id(@animal3)}" do
        expect(find("h3").text).to have_content("Abbey")

        photo = find(".photo img")
        expect(photo[:src]).to eq("http://www.se.test:9292/assets/default_small_photo.jpg")
        expect(photo[:alt]).to eq("Abbey - Cutie Mix")

        expect(find("ul li:nth-child(1)").text).to eq("Dog: Female")
        expect(find("ul li:nth-child(2)").text).to eq("Cutie Mix")
      end

      within "##{dom_id(@animal3)}" do
        expect(find("h3").text).to have_content("Abbey")

        photo = find(".photo img")
        expect(photo[:src]).to eq("http://www.se.test:9292/assets/default_small_photo.jpg")
        expect(photo[:alt]).to eq("Abbey - Cutie Mix")

        expect(find("ul li:nth-child(1)").text).to eq("Dog: Female")
        expect(find("ul li:nth-child(2)").text).to eq("Cutie Mix")
      end
    end

    xscenario "filter animals" do
      visit public_help_a_shelter_path(@shelter)

      click_link "Narrow your search results"

      #Type
      #Breed
      #Size
      #Sex
      #SPecial needs

      # #select dog
      # within "#animals" do
      #   animals = all(".animal")
      #   expect(animals.count).to eq(4)
      #   expect(page).to have_content("name")
      #   expect(page).to have_content("name2")
      # end

      # #select lab
      # within "#animals" do
      #   animals = all(".animal")
      #   expect(animals.count).to eq(4)
      #   expect(page).to have_content("name")
      #   expect(page).to have_content("name2")
      # end

      # #select female
      # within "#animals" do
      #   animals = all(".animal")
      #   expect(animals.count).to eq(1)
      #   expect(page).to have_content("name")
      #   expect(page).to have_content("name2")
      # end
    end
  end
end

