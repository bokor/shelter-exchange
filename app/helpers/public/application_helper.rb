module Public::ApplicationHelper

  def page_name
    if controller_name != "pages"
      "#{action_name}_#{controller_name}"
    else
      if request.path == "/"
        "home_page"
      else
        "#{request.path.parameterize('_')}_page"
      end
    end
  end
end

