module Public::ApplicationHelper
  
  def page_name
    @path.parameterize('_') unless @path.blank?
  end
  
end