Dir.chdir(Rails.root.join("app/views/public/pages"))
xml.instruct! 
xml.urlset "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
           "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
           "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9"  do
  # Home Page --------------------------------------------
  xml.url do
   xml.loc "#{full_url}/"
   xml.lastmod File.ctime("index.html.erb").strftime("%Y-%m-%d")
  end
  #---------------------------------------------
  
  #-Web Pages--------------------------------------------
  Dir.glob("*/**/").each do |d|
    xml.url do
     xml.loc "#{full_url}/#{d.chomp('/')}"
     xml.lastmod File.ctime(File.absolute_path("index.html.erb", d)).strftime("%Y-%m-%d")
    end
  end
  #---------------------------------------------
  
  #-Community :: Shelters--------------------------------------------
  xml.url do
   xml.loc public_help_a_shelter_index_url
   xml.lastmod @help_a_shelter_last_updated
  end
  @shelters.each do |shelter|
    xml.url do
     xml.loc public_help_a_shelter_url(shelter)
     # xml.lastmod shelter.updated_at.strftime("%Y-%m-%d")
     xml.changefreq "weekly"
    end
  end
  #---------------------------------------------
  
  #-Community :: Animals--------------------------------------------
  xml.url do
   xml.loc public_save_a_life_index_url
   xml.lastmod @save_a_life_last_updated
  end
  @animals.each do |animal|
    xml.url do
     xml.loc public_save_a_life_url(animal)
     xml.lastmod animal.updated_at.strftime("%Y-%m-%d")
     xml.changefreq "weekly"
    end
  end
  #---------------------------------------------
end

