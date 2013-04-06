class DocumentPresenter < Presenter

  def initialize(documents)
    @documents = documents
  end

  def to_uploader
    if @documents.is_a?(Array)
      @documents.collect{|object| as_uploader(object)}.to_json
    elsif @documents.is_a?(Document)
      [as_uploader(@documents)].to_json
    end
  end

  #-----------------------------------------------------------------------------
  private

  def as_uploader(document)
    {
      "name"        => document.original_name,
      "url"         => document.document.url,
      "delete_url"  => document_path(document),
      "delete_type" => "DELETE"
    }
  end
end

