xml.instruct!
 
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  Dir.glob("*/**/").each do |d|
    xml.url do
     xml.name "http://www.shelterexchange.org/#{d}"
    end
  end
end
