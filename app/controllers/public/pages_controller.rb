class Public::PagesController < Public::ApplicationController
  respond_to :html, :xml

  # caches_action :index, :expires_in => 1.hour
  # caches_action :show

  def index
    @animals = Animal.latest(:adopted, 3).all
    @lives_saved = Animal.adopted.limit(nil).count + Animal.transferred.limit(nil).count + Transfer.completed.limit(nil).count
    @active_shelters = Shelter.active.count
  end

  def show
    @path = params[:path]
    template = File.join('public/pages', @path)    # About/FAQ page /about/faq.html.erb
    template_with_index = template + "/index"      # About Page /about/index.html.erb
    render :template => template, :format => :html rescue
    render :template => template_with_index, :format => :html rescue
    render :file => "public/404", :format => :html, :layout => false, :status => :not_found
  end

  def sitemap
    sitemap_data = open("https://s3.amazonaws.com/shelterexchange/sitemaps/sitemap.xml.gz").read
    send_data( sitemap_data, disposition: "inline", :type => "application/x-gzip" )

    #redirect_to "https://s3.amazonaws.com/shelterexchange/sitemaps/sitemap.xml.gz"
  end

end

