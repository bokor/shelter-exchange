class RemoteLinkRenderer < WillPaginate::LinkRenderer
  def prepare(collection, options, template)
    @remote = options.delete(:remote) || {}
    super
  end

protected
  def page_link(page, text, attributes = {})
    @template.link_to(text, url_for(page), {:method => :get, :remote => true }.merge(@remote), attributes)
  end
end