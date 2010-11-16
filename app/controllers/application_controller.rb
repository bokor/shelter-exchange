class ApplicationController < ActionController::Base
  include SubdomainAccounts
  include SubdomainUsers
  
  protect_from_forgery
  before_filter :set_current_account
  helper_method :current_user_session, :current_user
  helper :all
  layout :current_layout_name
  
  private
  
    def set_current_account
      unless account_subdomain == default_account_subdomain
        redirect_to default_account_url if current_account.nil? 
      end
    end

    def current_layout_name
      public_site? ? 'public' : 'application'
    end
    
    def public_site?
      account_subdomain == default_account_subdomain
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

end
