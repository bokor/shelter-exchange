Dir.chdir(Rails.root.join("app/views/public/pages"))
xml.instruct! 
xml.urlset "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
           "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
           "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9"  do
  # Home Page --------------------------------------------
  xml.url do
    xml.loc "#{full_url}/"
    # xml.lastmod File.ctime("index.html.erb").strftime("%Y-%m-%d")
    xml.changefreq "daily"
    xml.priority "0.9"
  end
  #---------------------------------------------
  
  #-Web Pages--------------------------------------------
  Dir.glob("*/**/").each do |d|
    xml.url do
      xml.loc "#{full_url}/#{d.chomp('/')}"
      xml.lastmod File.ctime(File.absolute_path("index.html.erb", d)).strftime("%Y-%m-%d")
      xml.priority "0.8"
    end
  end
  #---------------------------------------------
  
  #-Signup Page--------------------------------------------
  Dir.chdir(Rails.root.join("app/views/public/accounts"))
  xml.url do
    xml.loc public_signup_url
    xml.lastmod File.ctime(File.absolute_path("new.html.erb")).strftime("%Y-%m-%d")
    xml.priority "0.8"
  end
  #---------------------------------------------
  
  #-Login Page--------------------------------------------
  Dir.chdir(Rails.root.join("app/views/public/users/sessions"))
  xml.url do
    xml.loc new_public_user_session_url
    xml.lastmod File.ctime(File.absolute_path("new.html.erb")).strftime("%Y-%m-%d")
    xml.priority "0.8"
  end
  #---------------------------------------------
  
  
  #-Community :: Shelters--------------------------------------------
  xml.url do
    xml.loc public_help_a_shelter_index_url
    xml.lastmod @help_a_shelter_last_updated
    xml.priority "0.8"
  end
  xml.url do
    xml.loc search_by_shelter_or_rescue_group_public_help_a_shelter_index_url
    xml.priority "0.8"
  end
  @shelters.find_each(:batch_size => 100) do |shelter|
    xml.url do
      xml.loc public_help_a_shelter_url(shelter)
      # xml.lastmod shelter.updated_at.strftime("%Y-%m-%d")
      xml.changefreq "weekly"
      xml.priority "0.7"
    end
  end
  #---------------------------------------------
  
  #-Community :: Animals--------------------------------------------
  xml.url do
    xml.loc public_save_a_life_index_url
    xml.lastmod @save_a_life_last_updated
    xml.priority "0.8"
  end
  @animals.find_each(:batch_size =>  100) do |animal|
    xml.url do
      xml.loc public_save_a_life_url(animal)
      # xml.lastmod animal.updated_at.strftime("%Y-%m-%d")
      xml.changefreq "daily"
      xml.priority "0.7"
    end
  end
  #---------------------------------------------
end

