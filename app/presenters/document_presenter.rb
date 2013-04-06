class DocumentPresenter < Presenter

  def initialize(document)
    @document = document
  end

  def self.as_uploader_collection(documents)
    documents.collect{|document| self.new(document).to_uploader }.flatten.to_json
  end

  def to_uploader
    [{
      :name        => @document.original_name,
      :url         => @document.document.url,
      :delete_url  => document_path(@document),
      :delete_type => "DELETE"
    }]
  end
end

