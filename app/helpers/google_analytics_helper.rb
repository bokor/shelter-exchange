module GoogleAnalyticsHelper

  def trackable_pageview
    route = Rails.application.routes.recognize_path(request.url, :method => request.method)
    # Replace data with customizations for google analytics
    route[:id] = "{id}" if route.has_key?(:id)

    trackable_path = URI.decode(url_for(route))
    trackable_path = "/" if trackable_path == "/pages"
    trackable_path
  end
end

