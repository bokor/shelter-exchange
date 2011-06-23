class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!,
                :current_account, :account_blocked?, :current_shelter,
                :set_time_zone, :store_location

  layout :current_layout

  private
  
    def current_account
      @current_account ||= Account.find_by_subdomain!(request.subdomains.last) unless RESERVED_SUBDOMAINS.include?(request.subdomains.last)
    end
    
    def current_shelter
      @current_shelter ||= @current_account.shelters.first if @current_account and user_signed_in?
    end
    
    def current_layout
      user_signed_in? ? 'application' : 'login'
    end
    
    def account_blocked?
      raise Exceptions::AccountBlocked if @current_account and @current_account.blocked?
    end
    
    def set_time_zone
      Time.zone = @current_shelter.time_zone unless @current_shelter.blank?
    end
    
    def store_location
      session[:"user_return_to"] = request.fullpath if request.get? && request.format.html? && !request.xhr? && !devise_controller? 
    end
    
    def after_sign_in_path_for(resource_or_scope)
      case resource_or_scope
        when :user, User
          session[:"user_return_to"].blank? ? dashboard_path.to_s : session[:"user_return_to"].to_s 
        else
          super
      end
    end
    
    def after_sign_out_path_for(resource_or_scope)
      case resource_or_scope
        when :user, User
          new_user_session_path
        else
          super
      end
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
    
    rescue_from Exceptions::AccountBlocked do |exception|
      render :template => 'errors/account_blocked'
    end
    
    rescue_from CanCan::AccessDenied do |exception|
      render :template => 'errors/unauthorized'
    end
    
    rescue_from ActiveRecord::RecordNotFound do |exception|
      redirect_to "/404.html"
    end

end