module Public::ApplicationHelper
  
  def page_name
    @path.blank? ? "home_page" : "#{@path.parameterize('_')}_page"
  end
  
end