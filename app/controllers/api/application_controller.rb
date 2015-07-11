class Api::ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :cors_access_control_headers
  before_filter :shelter_lookup, :shelter_inactive?

  layout :current_layout


  #-----------------------------------------------------------------------------
  private

  def cors_access_control_headers
    if request.format.json? || request.xhr?
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token, User-Agent, Keep-Alive, Cache-Control, If-Modified-Since'
      head(:ok) if request.method == :options
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

