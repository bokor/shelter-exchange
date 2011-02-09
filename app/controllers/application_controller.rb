class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all
  before_filter :authenticate_user!, :current_subdomain, :current_shelter #, :set_timezone
  layout :current_layout_name
  
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

    def current_layout_name
      @current_account.blank? ? 'public' : 'application'
    end
    
    def set_timezone
      # Time.zone = @current_shelter.time_zone
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
    
    

    

    
    # 
    # rescue ActiveRecord::RecordNotFound
    #   respond_to_not_found(:js, :xml, :html)
    # end
    #
    #   OLD WAY
    # include SubdomainAccounts
    #
    # def set_current_subdomain
    #   unless account_subdomain == default_account_subdomain
    #     redirect_to default_account_url if current_account.nil?
    #   end
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

end
