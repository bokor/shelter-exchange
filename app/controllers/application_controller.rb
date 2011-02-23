class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  
  before_filter :authenticate_user!, :current_subdomain, :current_shelter, :set_shelter_timezone
  before_filter :store_location, :set_mailer_url_options
  
  helper :all

  private
  
    def current_subdomain
      if request.subdomains.first.present? && request.subdomains.first != "www"
        begin
          @current_account = Account.find_by_subdomain!(request.subdomains.first) 
        rescue ActiveRecord::RecordNotFound
          logger.error("::: INVALID SUBDOMAIN => #{request.subdomains.first}")
          redirect_to "/404.html"
        end
      else 
        @current_account = nil
      end
    end
    
    def current_shelter
      if @current_account.present?
        @current_shelter = @current_account.shelters.first
      else
        @current_shelter = nil
      end
    end
    
    def set_shelter_timezone
      Time.zone = @current_shelter.time_zone unless @current_shelter.blank?
    end
    
    def store_location
      session[:"user_return_to"] = request.fullpath if request.get? && request.format.html? && !request.xhr? && !devise_controller? 
    end
        
    def after_sign_in_path_for(resource_or_scope)
      # session[:"user_return_to"].blank? ? root_path : session[:"user_return_to"].to_s
      session[:"user_return_to"].to_s unless session[:"user_return_to"].blank?
    end
    
    def set_mailer_url_options
      ActionMailer::Base.default_url_options[:host] = with_subdomain(request.subdomains.first)
    end

    
  protected
  
    def is_integer(test)
      test =~ /\A-?\d+\Z/
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

end


  
  # layout :current_layout_name

# def current_layout_name
#   @current_account.blank? ? 'public' : 'application'
# end


# Rails.cache.write(:current_account, Account.find_by_subdomain!(request.subdomains.first)) if Rails.cache.read(:current_account).blank?
# @current_account = Rails.cache.read(:current_account)


# if current_subdomain == 'admin'
# authenticate_admin!
# else
# authenticate_user!
# end