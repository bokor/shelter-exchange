class Public::ApplicationController < ActionController::Base
  protect_from_forgery
    
  layout :current_layout

  private
      
    def current_layout
      'public/application'
    end

end

# MOVED TO NGINX CONFIG
# before_filter :authenticate! if Rails.env.demo? or Rails.env.staging?  
  
# def authenticate!   
#   authenticate_or_request_with_http_basic do |username, password|
#     username == "shelterexchange" && password == "sav1ngl1ves"
#   end
# end