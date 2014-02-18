module GoogleAnalyticsHelper

  def trackable_pageview
    trackable_path = request.path
    found          = Rails.application.routes.router.recognize(request){}

    unless found.empty?
      match, parameters, route = found.first
      route_path = route.path.spec.to_s

      unless route_path.include?("*path")
        route_string   = route_path.gsub("(.:format)", "")

        if route_string.include?(":id")
          trackable_path = route_string.gsub(/:(\w+)?/, '{id}') # Replace dynamic segments with {id}
        end
      end
    end

    trackable_path
  end
end

