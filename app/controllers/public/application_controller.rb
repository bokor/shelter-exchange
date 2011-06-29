class Public::ApplicationController < ActionController::Base
  protect_from_forgery
  
  # before_filter nil

  layout :current_layout

  private
      
    def current_layout
      'public/application'
    end

end