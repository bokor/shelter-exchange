class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!, :current_account, :current_shelter, :shelter_suspended?,
                :set_time_zone, :store_location
                
  layout :current_layout
  


  private
  
    def current_account
      @current_account ||= Account.find_by_subdomain!(request.subdomains.last) unless request.subdomain.blank? or RESERVED_SUBDOMAINS.include?(request.subdomains.last)
    end
    
    def current_shelter 
      @current_shelter ||= @current_account.shelters.first if @current_account and user_signed_in?
    end
    
    def current_layout
      user_signed_in? ? 'app/application' : 'app/login'
    end
    
    def shelter_suspended?
      raise Exceptions::ShelterSuspended if @current_shelter and @current_shelter.suspended?
    end
    
    def set_time_zone
      Time.zone = @current_shelter.time_zone unless @current_shelter.blank?
    end
    
    # def force_ssl!
    #   redirect_to :protocol => "https://" unless (request.ssl? or local_request?)
    #   # redirect_to url_for params.merge({:protocol => 'https://'}) 
    # end
    # 
    # def local_request?
    #   Rails.env.development? or Rails.env.staging? or Rails.env.demo?
    # end
    
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
    
    rescue_from Exceptions::ShelterSuspended do |exception|
      render :template => 'errors/shelter_suspended'
    end
    
    rescue_from CanCan::AccessDenied do |exception|
      render :template => 'errors/unauthorized'
    end
    
    rescue_from ActiveRecord::RecordNotFound do |exception|
      redirect_to "/404.html"
    end

end