class Public::ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :force_non_ssl
  before_filter :authenticate! if Rails.env.staging?

  layout :current_layout

  #-----------------------------------------------------------------------------
  private

  def force_non_ssl
    redirect_to :protocol => "http://" if request.ssl?
  end

  def local_request?
    Rails.env.development? || Rails.env.test? || request.local?
  end

  def current_layout
    if params[:layout].present? && template_exists?(params[:layout], "layouts/public")
      "public/#{params[:layout]}"
    else
      "public/application"
    end
  end

  def authenticate!
    users = {
      "shelterexchange" => "sav1ngl1ves",
      "testing"         => "8thank8you8"
    }
    authenticate_or_request_with_http_digest do |username|
      users[username]
    end
  end
end


