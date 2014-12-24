require 'rails_helper'

describe DocumentUploader do

  before do
    @file = File.open(Rails.root.join("spec/data/documents/testing.pdf"))
    @note = Note.gen
    @document = Document.gen :document => @file, :attachable => @note
    @uploader = DocumentUploader.new @document, :document
  end

  it "has storage set correctly" do
    expect(DocumentUploader.storage).to eq(CarrierWave::Storage::Fog)
  end

  describe '#store_dir' do
    it "has a correct storage path" do
      expect(@uploader.store_dir).to eq("notes/documents/#{@note.id}/original")
    end
  end

  describe '#full_filename' do
    it "sets the full filename" do
      expect(@uploader.full_filename(@document.document.file)).to eq(@document.document.file)
    end
  end

  describe '#filename' do
    it "returns a customized filename" do
      expect(@document.document.filename).to eq("#{@document.guid}.pdf")
    end
  end
end

