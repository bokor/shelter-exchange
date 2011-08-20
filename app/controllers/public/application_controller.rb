class Public::ApplicationController < ActionController::Base
  protect_from_forgery
  
  USERNAME, PASSWORD = "shelterexchange", "sav1ngl1ves"
  before_filter :authenticate if Rails.env.staging? or Rails.env.demo?
  
  layout :current_layout


  private
      
    def current_layout
      'public/application'
    end
    
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == USERNAME &&
        Digest::SHA1.hexdigest(password) == PASSWORD
      end
    end

end