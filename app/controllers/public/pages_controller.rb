class Public::PagesController < Public::ApplicationController
  respond_to :html
  
  # caches_page :index, :show
    
  def index
    # Home Page = /
  end
  
  def show
    @path = params[:path]
    template = File.join('public/pages', @path)    # About/FAQ page /about/faq.html.erb
    template_with_index = template + "/index"      # About Page /about/index.html.erb
    render :template => template rescue render :template => template_with_index rescue redirect_to "/404.html"
  end
  
end
