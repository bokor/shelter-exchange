class Public::ApplicationController < ActionController::Base
  protect_from_forgery
  
  USERS = { "shelterexchange" => "sav1ngl1ves" }
  before_filter :authenticate! if Rails.env.demo? or Rails.env.staging?
  
  layout :current_layout

  private
      
    def current_layout
      'public/application'
    end
    
    def authenticate!
      authenticate_or_request_with_http_digest do |username|
        USERS[username]
      end
    end

end