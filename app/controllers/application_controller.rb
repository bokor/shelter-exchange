class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  
  before_filter :authenticate_user!, :current_account, :current_shelter, :set_shelter_timezone
  before_filter :store_location, :set_mailer_url_options

  layout :current_layout
  # helper :all
  # clear_helpers

  private
  
    def current_account
      @current_account ||= Account.find_by_subdomain!(request.subdomains.first)
      # raise AccessBlocked if @current_account.blocked?
    end
    
    def current_shelter
      @current_shelter ||= @current_account.shelters.first if user_signed_in?
    end
    
    def current_layout
      if @current_account.blank?
        'public'
      else
        user_signed_in? ? 'application' : 'login'
      end
    end
    
    def set_shelter_timezone
      Time.zone = @current_shelter.time_zone unless @current_shelter.blank?
    end
    
    def store_location
      session[:"user_return_to"] = request.fullpath if request.get? && request.format.html? && !request.xhr? && !devise_controller? 
    end
        
    def after_sign_in_path_for(resource)
       session[:"user_return_to"].blank? ? "/" : session[:"user_return_to"].to_s 
    end
    
    def set_mailer_url_options
      ActionMailer::Base.default_url_options[:host] = with_subdomain(request.subdomains.first)
    end

    
  protected
  
    def is_integer?(value)
      value =~ /\A-?\d+\Z/
    end
    
    def find_polymorphic_class
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
    
    rescue_from CanCan::AccessDenied do |exception|
      render :template => 'errors/unauthorized'
    end
    
    rescue_from ActiveRecord::RecordNotFound do |exception|
      redirect_to "/404.html"
    end

end