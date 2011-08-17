module Public::ApplicationHelper
  
  def page_name
    @path = request.path if @path.blank?
    @path.blank? ? "home_page" : "#{@path.parameterize('_')}_page"
  end
  
end