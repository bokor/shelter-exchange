require "rails_helper"

feature "Animal list for the API (iframe)" do

  background do
    switch_to_subdomain("api")
    @current_shelter = Shelter.gen :access_token => "12345", :status => "active"
  end

  scenario "lists all animals for the default type and status" do
    type_dog = AnimalType.gen :id => 1, :name => "Dog"
    type_cat = AnimalType.gen :id => 2, :name => "Cat"
    available_for_adoption = AnimalStatus.gen :id => 1, :name => "Available for adoption"

    dog = Animal.gen(
      :animal_status => available_for_adoption,
      :animal_type=> type_dog,
      :name => "Billy",
      :primary_breed => "Labrador Retriever",
      :is_mix_breed => true,
      :sex => "Male",
      :shelter => @current_shelter
    )
    dog_photo = Photo.gen(:attachable => dog, :is_main_photo => false)

    cat = Animal.gen(
      :animal_status => available_for_adoption,
      :animal_type => type_cat,
      :name => "Princess",
      :primary_breed => "Calico",
      :is_mix_breed => false,
      :sex => "Female",
      :shelter => @current_shelter
    )

    not_listed = Animal.gen :animal_status_id => 2, :shelter => @current_shelter

    visit "/animals.html?access_token=12345"

    within "#animals .animal_list" do
      expect(page).to have_no_css("##{dom_id(not_listed)}")

      within "##{dom_id(dog)}" do
        within ".image" do
          expect(find("img")[:src]).to include(dog_photo.image.url(:thumb))
        end

        expect(find_link("Billy")[:href]).to include(public_save_a_life_path(dog, :subdomain => "www"))
        expect(page).to have_content("Labrador Retriever Mix")
        expect(page).to have_content("Dog: Male (Sterilized)")
        expect(page).to have_content("Available for adoption")
      end

      within "##{dom_id(cat)}" do
        within ".image" do
          expect(find("img")[:src]).to include("/assets/default_thumb_photo.jpg")
        end

        expect(find_link("Princess")[:href]).to include(public_save_a_life_path(cat, :subdomain => "www"))
        expect(page).to have_content("Calico")
        expect(page).to have_content("Cat: Female")
        expect(page).to have_content("Available for adoption")
      end
    end
  end

  context "with filtering", :js => true do

    background do
      type_dog = AnimalType.gen :id => 1, :name => "Dog"
      type_cat = AnimalType.gen :id => 2, :name => "Cat"
      available_for_adoption = AnimalStatus.gen :id => 1, :name => "Available for adoption"

      @dog = Animal.gen(
        :name => "Billy", :primary_breed => "Labrador Retriever", :sex => "Male", :size => "L", :has_special_needs => false,
        :animal_status => available_for_adoption, :animal_type=> type_dog, :shelter => @current_shelter
      )

      @dog2 = Animal.gen(
        :name => "Jimmy", :primary_breed => "Golden Retriever", :sex => "Male", :size => "M", :has_special_needs => true,  :special_needs => "special",
        :animal_status => available_for_adoption, :animal_type=> type_dog, :shelter => @current_shelter
      )

      @cat = Animal.gen(
        :name => "Princess", :primary_breed => "Calico", :sex => "Female", :size => "S", :has_special_needs => false,
        :animal_status => available_for_adoption, :animal_type => type_cat, :shelter => @current_shelter
      )
    end

    scenario "filter by type and breed" do
      visit "/animals.html?access_token=12345"

      click_link "Narrow your search results"

      within "#animals .animal_list" do
        expect(page).to have_css("##{dom_id(@dog)}")
        expect(page).to have_css("##{dom_id(@dog2)}")
        expect(page).to have_css("##{dom_id(@cat)}")
      end

      select "Dog", :from => "Type"

      within "#animals .animal_list" do
        expect(page).to have_css("##{dom_id(@dog)}")
        expect(page).to have_css("##{dom_id(@dog2)}")
        expect(page).to have_no_css("##{dom_id(@cat)}")
      end

      find("#filters_breed_chosen").click
      find(".active-result", :text => "Labrador Retriever").click

      within "#animals .animal_list" do
        expect(page).to have_css("##{dom_id(@dog)}")
        expect(page).to have_no_css("##{dom_id(@dog2)}")
        expect(page).to have_no_css("##{dom_id(@cat)}")
      end
    end

    scenario "filter by sex" do
      visit "/animals.html?access_token=12345"

      click_link "Narrow your search results"

      within "#animals .animal_list" do
        expect(page).to have_css("##{dom_id(@dog)}")
        expect(page).to have_css("##{dom_id(@dog2)}")
        expect(page).to have_css("##{dom_id(@cat)}")
      end

      select "Male", :from => "Sex"

      within "#animals .animal_list" do
        expect(page).to have_css("##{dom_id(@dog)}")
        expect(page).to have_css("##{dom_id(@dog2)}")
        expect(page).to have_no_css("##{dom_id(@cat)}")
      end
    end

    scenario "filter by size" do
      visit "/animals.html?access_token=12345"

      click_link "Narrow your search results"

      within "#animals .animal_list" do
        expect(page).to have_css("##{dom_id(@dog)}")
        expect(page).to have_css("##{dom_id(@dog2)}")
        expect(page).to have_css("##{dom_id(@cat)}")
      end

      select "Medium", :from => "Size"

      within "#animals .animal_list" do
        expect(page).to have_no_css("##{dom_id(@dog)}")
        expect(page).to have_css("##{dom_id(@dog2)}")
        expect(page).to have_no_css("##{dom_id(@cat)}")
      end
    end

    scenario "filter by special needs" do
      visit "/animals.html?access_token=12345"

      click_link "Narrow your search results"

      within "#animals .animal_list" do
        expect(page).to have_css("##{dom_id(@dog)}")
        expect(page).to have_css("##{dom_id(@dog2)}")
        expect(page).to have_css("##{dom_id(@cat)}")
      end

      check("Special needs animals")

      within "#animals .animal_list" do
        expect(page).to have_no_css("##{dom_id(@dog)}")
        expect(page).to have_css("##{dom_id(@dog2)}")
        expect(page).to have_no_css("##{dom_id(@cat)}")
      end
    end
  end

  context "with no animals" do

    scenario "shows error message" do
      visit "/animals.html?access_token=12345"

      within "#animals" do
        expect(find(".no_results h2").text).to eq("No Animals Found")
      end
    end
  end
end

