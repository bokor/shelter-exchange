class Public::Users::SessionsController < ::Devise::SessionsController
  include UrlHelper
  layout 'public/application'
  
  def new  
    sign_out(:user) # Added because we aren't allowing to be signed into WWW site.    
  end
  
  def create        
    # Map the controller for the user session in www 
    Devise.mappings[:user].controllers[:sessions] = "public/users/sessions"
    
    # Find the user per email and get their subdomain
    user = User.where(:email => params[:user][:email]).first
    params[:user][:subdomain] = user.account.subdomain unless user.blank?
    
    # Authenticate User
    resource = warden.authenticate!(:scope => :user, :recall => "#{controller_path}#new")
    
    # Try to sign in the user and redirect to subdomain URL
    sign_in_and_redirect(:user, resource)
  end 
  
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    current_user.authentication_token = Devise.friendly_token
    current_user.save
    sign_out(:user)
 
    redirect_to valid_token_user_url(current_user.authentication_token, :subdomain => current_user.account.subdomain )
  end  
  
end

# resource = warden.authenticate!(:scope => :user, :recall => "#{controller_path}#new")
# set_flash_message(:notice, :signed_in) if is_navigational_format?
# sign_in(:user, resource)

# params[:user][:subdomain] = @subdomain 
# resource = User.find_for_authentication

# def sign_in(resource_or_scope, resource=nil)
#   super
#   sign_in_and_redirect(:user, resource)
# end


# class Public::Users::SessionsController < ::Devise::SessionsController
#   include UrlHelper
#   layout 'public/application'
#   
#   def new  
#     # sign_out(:user) # Added because we aren't allowing to be signed into WWW site.
#     Devise.sign_out_all_scopes ? sign_out : sign_out(:user)
#     set_flash_message :notice, :signed_out if signed_in?(:user)
#   end
#   
#   def create 
#     Devise.mappings[:user].controllers[:sessions] = "public/users/sessions"
#     user = User.where(:email => params[:user][:email]).first
#     
#     if user.present? 
#       if user.confirmed?
#         params[:user][:subdomain] = user.account.subdomain
#         resource = warden.authenticate!(:scope => :user)
#         sign_in_and_redirect(:user, resource)
#       else
#         not_confirmed = true
#       end
#     end
#     
#     set_flash_message :notice, not_confirmed ? :unconfirmed : :invalid
#     render :new
#     
#   end 
# 
#   
#   def sign_in_and_redirect(resource_or_scope, resource=nil)
#     scope = Devise::Mapping.find_scope!(resource_or_scope)
#     resource ||= resource_or_scope
#     sign_in(scope, resource) unless warden.user(scope) == resource
#     
#     current_user.authentication_token = Devise.friendly_token
#     current_user.save
#     sign_out(:user)
#     
#     redirect_to valid_token_user_url(current_user.authentication_token, :subdomain => current_user.account.subdomain) && return
#   end  
#   
# end