class Admin::ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_owner!, :store_location
  layout :current_layout
  

  private
  
    def current_layout
      owner_signed_in? ? 'admin/application' : 'admin/login'
    end
      
    def store_location
      session[:"owner_return_to"] = request.fullpath if request.get? && request.format.html? && !request.xhr? && !devise_controller? 
    end
            
  protected
    
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end

end