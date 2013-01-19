class Public::ApplicationController < ActionController::Base
  protect_from_forgery
  
  http_basic_authenticate_with :name => "shelterexchange", :password => "sav1ngl1ves" if Rails.env.staging?
    
  layout :current_layout

  private
      
    def current_layout
      if params[:layout].present? && template_exists?(params[:layout], "layouts/public")
        "public/#{params[:layout]}"
      else
        "public/application"
      end
    end
end

  
