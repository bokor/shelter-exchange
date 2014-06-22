require 'spec_helper'

describe DocumentPresenter do

  before do
    file1 = File.open("#{Rails.root}/spec/data/documents/testing.pdf")
    file2 = File.open("#{Rails.root}/spec/data/documents/testing.docx")
    @note = Note.gen
    @document1 = Document.gen :document => file1, :attachable => @note
    @document2 = Document.gen :document => file2, :attachable => @note
  end

  describe "#to_uploader" do
    it "returns an array representing the document" do
      presenter = DocumentPresenter.new(@document1)
      expect(presenter.to_uploader).to match_array([
        {
          :name => "testing.pdf",
          :url => "https://shelterexchange-test.s3.amazonaws.com/notes/documents/#{@note.id}/original/#{@document1.document.filename}",
          :delete_url => "/documents/#{@document1.id}",
          :delete_type => "DELETE"
        }
      ])
    end
  end

  describe ".as_uploader_collection" do
    it "returns multiple documents to uploader json" do
      json = DocumentPresenter.as_uploader_collection([@document1, @document2])

      expect(MultiJson.load(json)).to match_array([
        {
          "name" => "testing.pdf",
          "url" => "https://shelterexchange-test.s3.amazonaws.com/notes/documents/#{@note.id}/original/#{@document1.document.filename}",
          "delete_url" => "/documents/#{@document1.id}",
          "delete_type" => "DELETE"
        }, {
          "name" => "testing.docx",
          "url" => "https://shelterexchange-test.s3.amazonaws.com/notes/documents/#{@note.id}/original/#{@document2.document.filename}",
          "delete_url" => "/documents/#{@document2.id}",
          "delete_type" => "DELETE"
        }
      ])
    end
  end
end

