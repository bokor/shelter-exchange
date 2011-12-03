class Public::ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate! if Rails.env.demo? or Rails.env.staging?
    
  layout :current_layout

  private
      
    def current_layout
      'public/application'
    end
    
    def authenticate!   
      authenticate_or_request_with_http_basic do |username, password|
        (username == "shelterexchange" && password == "sav1ngl1ves") || 
        (username == "testaccount" && password == "shelterexchange2011")
      end
    end

end

  
