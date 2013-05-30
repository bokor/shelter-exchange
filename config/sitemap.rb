# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.shelterexchange.org"

SitemapGenerator::Sitemap.create do

  #-Web Pages--------------------------------------------
  Dir.chdir(Rails.root.join("app/views/public/pages"))
  Dir.glob("*/**/").each do |d|
    page_lastmod = File.ctime(File.absolute_path("index.html.erb", d)).strftime("%Y-%m-%d")
    add "#{d.chomp('/')}", :lastmod => page_lastmod, :priority => "0.6"
  end
  #---------------------------------------------

  #-Signup Page--------------------------------------------
  Dir.chdir(Rails.root.join("app/views/public/accounts"))
  signup_lastmod   = File.ctime(File.absolute_path("new.html.erb")).strftime("%Y-%m-%d")
  add public_signup_path, :lastmod => signup_lastmod, :priority => "0.6"
  #---------------------------------------------

  #-Login Page--------------------------------------------
  Dir.chdir(Rails.root.join("app/views/public/users/sessions"))
  login_lastmod   = File.ctime(File.absolute_path("new.html.erb")).strftime("%Y-%m-%d")
  add new_public_user_session_path, :lastmod => login_lastmod, :priority => "0.5"
  #---------------------------------------------

  #-Help a Shelter :: Shelters--------------------------------------------
  add public_help_a_shelter_index_path,
    :lastmod => Shelter.select(:updated_at).active.order("updated_at DESC").first.updated_at.strftime("%Y-%m-%d"),
    :priority => "0.7"

  add search_by_shelter_or_rescue_group_public_help_a_shelter_index_path,
    :priority => "0.6"

  shelters = Shelter.select(:id).active
  shelters.find_each(:batch_size => 100) do |shelter|
    add public_help_a_shelter_path(shelter),
      :changefreq => "weekly",
      :priority => "0.7"
  end
  #---------------------------------------------

  #-Save a life :: Animals--------------------------------------------
  add public_save_a_life_index_path,
    :lastmod  => Animal.select(:updated_at).order(:updated_at).first.updated_at.strftime("%Y-%m-%d"),
    :priority => "0.8"

  animals = Animal.select("animals.id").joins(:shelter).where(:shelters => {:status => "active"}).available
  animals.find_each(:batch_size => 100) do |animal|
    add public_save_a_life_path(animal),
      :changefreq => "daily",
      :priority => "0.8"
  end
  #---------------------------------------------

end

