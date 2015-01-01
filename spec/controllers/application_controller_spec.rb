require "rails_helper"

describe ApplicationController do
  # Testing this with Request Specs
  #
  # TODO: Might have a better way to do this once Devise is upgraded but not sure

  # controller(ApplicationController) do
  #   def index
  #     render nothing: true
  #   end
  # end
end


# class ApplicationController < ActionController::Base
#   protect_from_forgery
#   force_ssl :unless => :local_request?
#
#   before_filter :authenticate_user!,
#                 :current_account,
#                 :current_shelter,
#                 :shelter_inactive?,
#                 :shelter_time_zone,
#                 :store_location,
#                 :disable_application
#
#   layout :current_layout
#
#   def current_account
#     unless request.subdomain.blank? || RESERVED_SUBDOMAINS.include?(request.subdomains.last)
#       @current_account ||= Account.find_by_subdomain!(request.subdomains.last)
#     end
#   end
#
#   def current_shelter
#     @current_shelter ||= @current_account.shelters.first if @current_account && user_signed_in?
#   end
#
#   def local_request?
#     Rails.env.development? || Rails.env.test?
#   end
#
#   def disable_application
#     if ShelterExchange.settings.app_disabled?
#       render 'errors/app_disabled', :format => :html
#     end
#   end
#
#   #-----------------------------------------------------------------------------
#   private
#
#   def current_layout
#     user_signed_in? ? "app/application" : "app/login"
#   end
#
#   def shelter_inactive?
#     raise Errors::ShelterInactive if @current_shelter && @current_shelter.inactive?
#   end
#
#   def shelter_time_zone
#     Time.zone = @current_shelter.time_zone unless @current_shelter.blank?
#   end
#
#   def store_location
#     session[:"user_return_to"] = request.fullpath if request.get? && request.format.html? && !request.xhr? && !devise_controller?
#   end
#
#   def after_sign_in_path_for(resource_or_scope)
#     case resource_or_scope
#       when :user, User
#         session[:"user_return_to"].blank? ? dashboard_path.to_s : session[:"user_return_to"].to_s
#       else
#         super
#     end
#   end
#
#   def after_sign_out_path_for(resource_or_scope)
#     case resource_or_scope
#       when :user, User
#         new_user_session_path
#       else
#         super
#     end
#   end
#
#   #-----------------------------------------------------------------------------
#   protected
#
#   def find_polymorphic_class
#     params.each do |name, value|
#       if name =~ /(.+)_id$/
#         return $1.classify.constantize.find(value)
#       end
#     end
#     nil
#   end
#
#   rescue_from Errors::ShelterInactive do |exception|
#     render :template => "errors/shelter_#{@current_shelter.status}", :format => :html
#   end
#
#   rescue_from CanCan::AccessDenied do |exception|
#     render :template => 'errors/unauthorized', :format => :html
#   end
#
#   rescue_from ActiveRecord::RecordNotFound do |exception|
#     render :file => "public/404", :format => :html, :layout => false, :status => :not_found
#   end
# end
#

