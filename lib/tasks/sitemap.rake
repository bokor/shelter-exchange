sitemap = "http://www.shelterexchange.org/sitemap.xml"
search_engines = ["http://www.google.com/webmasters/tools/ping?sitemap=",
                  "http://www.bing.com/webmaster/ping.aspx?siteMap=",
                  "http://submissions.ask.com/ping?sitemap=",
                  "http://api.moreover.com/ping?u="]


namespace :sitemap do

  desc "ping search engines about a change in sitemap"
  task :ping do
    search_engines.each do |url|
      sh "curl #{url}#{sitemap}"
    end
  end

end
