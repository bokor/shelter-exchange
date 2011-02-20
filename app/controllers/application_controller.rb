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
      session[:"user.return_to"] = request.referrer
    end
        
    def after_sign_in_path_for(resource_or_scope)
      (session[:"user.return_to"].nil?) ? "/" : session[:"user.return_to"].to_s
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


# Devise Addition
# 
# def after_sign_in_path_for(resource_or_scope)
#   scope = Devise::Mapping.find_scope!(resource_or_scope)
#   subdomain_name = current_user.subdomain.name
#   if current_subdomain.nil? 
#     # logout of root domain and login by token to subdomain
#     token =  Devise.friendly_token
#     current_user.loginable_token = token
#     current_user.save
#     sign_out(current_user)
#     flash[:notice] = nil
#     home_path = valid_user_url(token, :subdomain => subdomain_name)
#     return home_path 
#   else
#     if subdomain_name != current_subdomain.name 
#       # user not part of current_subdomain
#       sign_out(current_user)
#       flash[:notice] = nil
#       flash[:alert] = "Sorry, invalid user or password for subdomain"
#     end
#   end
#   super
# end
