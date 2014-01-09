require 'spec_helper'

describe AttachmentUploader do

  it "contains a processor for setting content type" do
    AttachmentUploader.processors.should include [:set_content_type, true, nil]
  end

  it "has storage set correctly" do
    AttachmentUploader.storage.should == CarrierWave::Storage::Fog
  end

  describe '#store_dir' do
    it "has a correct store directory" do
      @file = File.open(Rails.root.join("spec/data/documents/testing.pdf"))
      @account = Account.gen :document => @file
      @uploader = AttachmentUploader.new @account, :document
      @uploader.store_dir.should == "accounts/documents/#{@account.id}/original"
    end
  end
end

