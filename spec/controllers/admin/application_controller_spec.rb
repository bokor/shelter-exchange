require "rails_helper"

describe Admin::ApplicationController do
  # Testing this with Request Specs
  #
  # TODO: Might have a better way to do this once Devise is upgraded but not sure

  # controller(Admin::ApplicationController) do
  #   def index
  #     render nothing: true
  #   end
  # end
end


# class Admin::ApplicationController < ActionController::Base
#   protect_from_forgery
#   force_ssl :unless => :local_request?
#
#   before_filter :authenticate_owner!, :store_location
#   layout :current_layout
#
#   #-----------------------------------------------------------------------------
#   private
#
#   def current_layout
#     owner_signed_in? ? 'admin/application' : 'admin/login'
#   end
#
#   def local_request?
#     Rails.env.development? || Rails.env.test?
#   end
#
#   def store_location
#     session[:"owner_return_to"] = request.fullpath if request.get? && request.format.html? && !request.xhr? && !devise_controller?
#   end
#
#   #-----------------------------------------------------------------------------
#   protected
#
#   rescue_from ActiveRecord::RecordNotFound do |exception|
#     render :file => "public/404", :format => :html, :layout => false, :status => :not_found
#   end
#
# end


