class Signup::ApplicationController < ActionController::Base
  protect_from_forgery

  layout :current_layout


  private
      
    def current_layout
      'signup/application'
    end

end