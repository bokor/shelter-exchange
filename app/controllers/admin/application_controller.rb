class Admin::ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_owner!, :store_location

  layout :current_layout

  private
  
    def current_layout
      owner_signed_in? ? 'admin/application' : 'admin/login'
    end
      
    def store_location
      session[:"owner_return_to"] = request.fullpath if request.get? && request.format.html? && !request.xhr? && !devise_controller? 
    end
        
    def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Owner)
        session[:"owner_return_to"].blank? ? dashboard_path.to_s : session[:"owner_return_to"].to_s 
      else
        super
      end
    end

    def after_sign_out_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Owner)
        new_owner_session_path
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
    
    rescue_from ActiveRecord::RecordNotFound do |exception|
      redirect_to "/404.html"
    end

end