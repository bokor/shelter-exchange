module Public::ApplicationHelper
  
  # SEO Helpers
  #----------------------------------------------------------------------------
  def description(description)
    content_for(:description) { description.to_s }
  end
  
  def keywords(keywords)
    content_for(:keywords) { keywords.to_s }
  end
  
  def robots(robots)
    content_for(:robots) { robots.to_s }
  end

  def seo_location(seo_location)
    content_for(:seo_location) { seo_location.to_s }
  end
  
  def seo_image(seo_image)
    content_for(:seo_image) { seo_image.to_s }
  end
  #----------------------------------------------------------------------------
  
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