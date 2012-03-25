class Public::ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :default_response_format
  before_filter :authenticate! if Rails.env.demo? or Rails.env.staging?
    
  layout :current_layout

  private
      
    def current_layout
      if params[:layout].present? && template_exists?(params[:layout], "layouts/public")
        "public/#{params[:layout]}"
      else
        "public/application"
      end
    end
    
    # REMOVE WHEN History JS fixed = Force HTML format when it comes in as a generic request curl (curl -v -H "Accept: */*;q=0.1" http://www.lvh.me:3000/save_a_life/4)
    def default_response_format
      request.format = :html if request.format.to_s.include?('*/*;q=')
    end
    
    def authenticate!   
      authenticate_or_request_with_http_basic do |username, password|
        (username == "shelterexchange" && password == "sav1ngl1ves") || 
        (username == "testaccount" && password == "shelterexchange2011")
      end
    end

end

  
