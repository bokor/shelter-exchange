module Public::ApplicationHelper
  
  def page_name
    if controller_name != "pages"
      "#{action_name}_#{controller_name}"
    else
      @path.blank? ? "home_page" : "#{@path.parameterize('_')}_page"
    end
  end
end