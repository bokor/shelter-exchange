class Public::Users::SessionsController < ::Devise::SessionsController
  include UrlHelper
  layout 'public/application'
  
  def new  
    sign_out(:user) # Added because we aren't allowing to be signed into WWW site.
  end
  
  def create 
    Devise.mappings[:user].controllers[:sessions] = "public/users/sessions"
    user = User.where(:email => params[:user][:email]).first
    begin
      params[:user][:subdomain] = user.account.subdomain
      resource = warden.authenticate!(:scope => :user)
      sign_in_and_redirect(:user, resource)
    rescue
      render :new
    end
  end 
  
  
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    
    current_user.authentication_token = Devise.friendly_token
    current_user.save
    sign_out(:user)
    
    redirect_to valid_token_user_url(current_user.authentication_token, :subdomain => current_user.account.subdomain)
  end  
  
end