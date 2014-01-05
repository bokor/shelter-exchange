# https://github.com/kjvarga/sitemap_generator

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.shelterexchange.org"
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new({
  :aws_access_key_id => ShelterExchange.settings.aws_access_key_id,
  :aws_secret_access_key => ShelterExchange.settings.aws_secret_access_key,
  :fog_provider => 'AWS',
  :fog_directory => ShelterExchange.settings.s3_bucket
})
# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ShelterExchange.settings.s3_bucket}.s3.amazonaws.com/"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'


SitemapGenerator::Sitemap.create do

  #-Web Pages--------------------------------------------
  Dir.chdir(Rails.root.join("app/views/public/pages"))
  Dir.glob("*/**/").each do |d|
    page_lastmod = File.ctime(File.absolute_path("index.html.erb", d)).strftime("%Y-%m-%d")
    add "#{d.chomp('/')}", :lastmod => page_lastmod, :priority => "0.6"
  end
  #---------------------------------------------

  #-Signup Page--------------------------------------------
  add public_signup_path, :changefreq => "monthly", :priority => "0.6"
  #---------------------------------------------

  #-Login Page--------------------------------------------
  add new_public_user_session_path, :changefreq => "monthly", :priority => "0.5"
  #-------------------------------------------------------

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
  #-------------------------------------------------------------------

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
  #-------------------------------------------------------------------

end

