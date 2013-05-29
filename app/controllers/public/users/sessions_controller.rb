class Public::Users::SessionsController < ::Devise::SessionsController
  include UrlHelper
  layout 'public/application'
  before_filter :force_ssl

  def new
    # Force Signout because www is not allowed to have a sign in per se
    sign_out(:user)
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

  #-----------------------------------------------------------------------------
  private

  def force_ssl
    unless Rails.env.development? || Rails.env.test? || request.ssl?
      redirect_to :protocol => 'https'
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    auth_token = Devise.friendly_token
    current_user.update_attributes(:authentication_token => auth_token)

    sign_out(:user)
    redirect_to valid_token_user_url(auth_token, :subdomain => current_user.account.subdomain)
  end
end

