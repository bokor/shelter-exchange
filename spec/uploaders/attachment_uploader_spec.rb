require 'spec_helper'

describe AttachmentUploader do

  before do
    @file = File.open(Rails.root.join("spec/data/documents/testing.pdf"))
    @account = Account.gen :document => @file
    @uploader = AttachmentUploader.new @account, :document
  end

  it "has storage set correctly" do
    expect(AttachmentUploader.storage).to eq(CarrierWave::Storage::Fog)
  end

  describe '#store_dir' do
    it "has a correct store directory" do
      expect(@uploader.store_dir).to eq("accounts/documents/#{@account.id}/original")
    end
  end
end

