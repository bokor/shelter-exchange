class Public::ApplicationController < ActionController::Base
  protect_from_forgery
   
  before_filter :authenticate! if Rails.env.staging? or Rails.env.demo?
  
  layout :current_layout

  private
      
    def current_layout
      'public/application'
    end
    
    def authenticate!
      username, password = "shelterexchange", "sav1ngl1ves"
      authenticate_or_request_with_http_basic do |user, pass|
        u == username &&
        Digest::SHA1.hexdigest(p) == password
      end
    end

end