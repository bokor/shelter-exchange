class DocumentPresenter < Presenter

  def initialize(document)
    @document = document
  end

  def to_uploader
    {
      "name"        => @document.original_name,
      "url"         => @document.document.url,
      "delete_url"  => document_path(@document),
      "delete_type" => "DELETE"
    }
  end

  def self.as_uploader(documents)
    documents.collect{|object| self.new(object).to_uploader}.to_json
  end
end
