sitemap = "http://www.shelterexchange.org/sitemap.xml"
search_engines = ["http://www.google.com/webmasters/tools/ping?sitemap=",
                  "http://www.bing.com/webmaster/ping.aspx?sitemap=",
                  "http://search.yahooapis.com/SiteExplorerService/V1/ping?sitemap="]
                  

namespace :sitemaps do
  
  desc "ping search engines about a change in sitemap"
  task :ping do
    search_engines.each do |url|
      # Update with HTTP Party, Rest Client or Event Machine
      sh "curl #{url}#{sitemap}"
    end
  end
  
end