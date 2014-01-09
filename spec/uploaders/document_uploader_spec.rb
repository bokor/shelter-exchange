require 'spec_helper'

describe DocumentUploader do

  before do
    @file = File.open(Rails.root.join("spec/data/documents/testing.pdf"))
    @note = Note.gen
    @document = Document.gen :document => @file, :attachable => @note
    @uploader = DocumentUploader.new @document, :document
  end

  it "contains a processor for setting content type" do
    DocumentUploader.processors.should include [:set_content_type, true, nil]
  end

  it "has storage set correctly" do
    DocumentUploader.storage.should == CarrierWave::Storage::Fog
  end

  describe '#store_dir' do
    it "has a correct storage path" do
      @uploader.store_dir.should == "notes/documents/#{@document.id}/original"
    end
  end

  describe '#full_filename' do
    it "sets the full filename" do
      @uploader.full_filename(@document.document.file).should == @document.document.file
    end
  end

  describe '#filename' do
    it "returns a customized filename" do
      @document.document.filename.should == "#{@document.guid}.pdf"
    end
  end
end

