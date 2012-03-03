module Public::ApplicationHelper
  
  def page_name
    if controller_name != "pages"
      "#{action_name}_#{controller_name}"
    else
      @path.blank? ? "home_page" : "#{@path.parameterize('_')}_page"
    end
  end
  
  def public_document_link(filename)
    compute_public_path(filename, "documents/public") unless filename.blank?
  end
  
end