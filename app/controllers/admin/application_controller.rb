class Admin::ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl :unless => :local_request?

  before_filter :authenticate_owner!
  layout :current_layout

  #-----------------------------------------------------------------------------
  private

  def current_layout
    owner_signed_in? ? 'admin/application' : 'admin/login'
  end

  def local_request?
    Rails.env.development? || Rails.env.test?
  end

  #-----------------------------------------------------------------------------
  protected

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :file => "public/404", :formats => [:html], :layout => false, :status => :not_found
  end
end

