require "rails_helper"

feature "Home Page" do

  background do
    switch_to_subdomain("www")
  end

  scenario "shows the total count of lives saved" do
    AnimalStatus::STATUSES.each do |status|
      Animal.gen(:animal_status_id => status[1])
    end

    transfer_animal = Animal.gen(:animal_status_id => 1)
    Transfer.gen(:status => "completed", :animal => transfer_animal)
    Transfer.gen(:status => "approved", :animal => transfer_animal)
    Transfer.gen(:status => "rejected", :animal => transfer_animal)

    visit "/"

    within("#lives_saved .stat_count") do
      expect(page).to have_content("3")
    end
  end

  scenario "shows the total count of active shelters" do
    Shelter::STATUSES.each do |status|
      Shelter.gen(:status => status)
    end

    visit "/"

    within("#active_shelters .stat_count") do
      expect(page).to have_content("1")
    end
  end

  scenario "shows the latest 3 adoptions in order newest to oldest" do
    adopted_shelter = Shelter.gen(:name => "Adopted Shelter", :city => "SE City", :state => "CA")
    adopted_shelter2 = Shelter.gen(:name => "Adopted Shelter2", :city => "Blah City", :state => "PA")

    Animal.gen(:name => "Adopted Joe", :animal_status_id => 2, :shelter => adopted_shelter,
               :status_history_date_month => "01", :status_history_date_day => "02", :status_history_date_year => "2015")
    Animal.gen(:name => "Adopted Johnny", :animal_status_id => 2, :shelter => adopted_shelter2,
               :status_history_date_month => "01", :status_history_date_day => "03", :status_history_date_year => "2015")
    Animal.gen(:name => "Adopted Jimmy", :animal_status_id => 2, :shelter => adopted_shelter,
               :status_history_date_month => "01", :status_history_date_day => "04", :status_history_date_year => "2015")
    Animal.gen(:name => "Adopted Bobby", :animal_status_id => 2, :shelter => adopted_shelter,
               :status_history_date_month => "01", :status_history_date_day => "05", :status_history_date_year => "2015")
    Animal.gen(:name => "NotAdopted", :animal_status_id => 1, :shelter => adopted_shelter,
               :status_history_date_month => "01", :status_history_date_day => "02", :status_history_date_year => "2015")

    visit "/"

    within ".adoptions .box:eq(1)" do
      expect(page).to have_content("Adopted Bobby")
      expect(page).to have_content("Jan 05")
      expect(page).to have_content("Adopted Shelter, SE City, CA")
    end

    within ".adoptions .box:eq(2)" do
      expect(page).to have_content("Adopted Jimmy")
      expect(page).to have_content("Jan 04")
      expect(page).to have_content("Adopted Shelter, SE City, CA")
    end

    within ".adoptions .box:eq(3)" do
      expect(page).to have_content("Adopted Johnny")
      expect(page).to have_content("Jan 03")
      expect(page).to have_content("Adopted Shelter2, Blah City, PA")
    end
  end
end

feature "All Site static pages should be accessible" do

  scenario "access all of the sites public pages" do
    switch_to_subdomain("www")

    Dir.chdir(Rails.root.join("app/views/public/pages"))
    page_paths = Dir.glob("**/*").select {|f| File.directory? f }

    page_paths.each do |p|
      visit "/#{p}"
      expect(page.status_code).to eq(200)
    end
  end
end

