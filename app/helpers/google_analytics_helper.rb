module GoogleAnalyticsHelper

  def trackable_pageview
    found = Rails.application.routes.router.recognize(request){}

    if found.empty?
      return request.path
    end

    match, parameters, route = found.first
    route_string = route.path.spec.to_s.gsub("(.:format)", "")

    # Replace dynamic segments with {id}
    route_string.gsub(/:(\w+)?/, '{id}')
  end

end

