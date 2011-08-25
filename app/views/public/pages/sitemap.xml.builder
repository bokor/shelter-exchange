Dir.chdir(Rails.root.join("app/views/public/pages"))
xml.instruct!
 
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  # Home Page --------------------------------------------
  xml.url do
   xml.loc "#{full_url}/"
   xml.lastmod File.ctime("index.html.erb").strftime("%Y-%m-%d")
  end
  #---------------------------------------------
  #-Web Pages--------------------------------------------
  Dir.glob("*/**/").each do |d|
    xml.url do
     xml.loc "#{full_url}/#{d}"
     xml.lastmod File.ctime(File.absolute_path("index.html.erb", d)).strftime("%Y-%m-%d")
    end
  end
  #-Community :: Shelters--------------------------------------------
  #-Community :: Animals--------------------------------------------
end

