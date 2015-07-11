class Api::ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :shelter_lookup, :shelter_inactive?
  before_filter :cors_preflight_check
  after_filter :cors_access_control_headers # Change to after_filter if we implement preflight check
  layout :current_layout


  #-----------------------------------------------------------------------------
  private

  def cors_preflight_check
    head(:ok) if request.method == "OPTIONS"
  end

  def cors_access_control_headers
    if request.format.json? || request.xhr?
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept, X-Requested-With, Session, Keep-Alive, User-Agent, If-Modified-Since, Cache-Control'
    end
  end

  def current_layout
    request.format.html? ? 'api/application' : false
  end

  def shelter_lookup
    @current_shelter = Shelter.by_access_token(params[:access_token]).first || respond_with_error({ :error => "Not Authorized to perform this action" })
  end

  def shelter_inactive?
    respond_with_error({ :error => "#{@current_shelter.name}'s access has been #{@current_shelter.status}" })  if @current_shelter.inactive?
  end

  def respond_with_error(msg)
    @error = msg[:error]
    respond_to do |format|
      format.html { render :template => "api/error", :format => :html }
      format.json { render :json => msg.to_json, :status => :forbidden }
    end
  end
end




# before_filter :cors_preflight_check
#
# These would still need to be updated and reviewed if implemented
#
# If this is a preflight OPTIONS request, then short-circuit the
# request, return only the necessary headers and return an empty
# text/plain
# def cors_preflight_check
#   if request.method == :options
#     headers['Access-Control-Allow-Origin'] = '*'
#     headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS, PUT, DELETE'
#     headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
#     headers['Access-Control-Max-Age'] = '1728000'
#     render :text => '', :content_type => 'text/plain'
#   end
# end

