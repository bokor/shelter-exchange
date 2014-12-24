require 'spec_helper'

describe ContactPhotoUploader do

  before do
    @file = File.open(Rails.root.join("spec/data/images/photo.jpg"))
    @contact = Contact.gen :photo => @file
    @uploader = ContactPhotoUploader.new @contact, :photo
  end

  it "has storage set correctly" do
    expect(ContactPhotoUploader.storage).to eq(CarrierWave::Storage::Fog)
  end

  describe "#extension_white_list" do
    it "has an extension white list" do
      expect(@uploader.extension_white_list).to match_array(["jpg", "jpeg", "gif", "png"])
    end
  end

  describe '#default_url' do
    it "has a original default url" do
      expect(@uploader.default_url).to eq("/assets/default_original_photo.jpg")
    end

    it "specific default url version" do
      expect(@uploader.small.default_url).to eq("/assets/default_small_photo.jpg")
      expect(@uploader.thumb.default_url).to eq("/assets/default_thumb_photo.jpg")
    end
  end

  describe '#store_dir' do
    it "has a correct store directory" do
      expect(@uploader.store_dir).to eq("contacts/photos/#{@contact.id}/original")
    end
  end

  describe '#full_filename' do
    it "sets the full filename" do
      expect(@uploader.full_filename(@contact.photo.file)).to eq(@contact.photo.file)
    end
  end

  describe '#filename' do
    it "returns a customized filename" do
      expect(@contact.photo.filename).to eq("#{@contact.guid}.jpg")
    end
  end

  context "after processing versions" do

    it "contains processor to resize to limit" do
      expect(@uploader.processors).to include [:resize_to_limit, [500, 500], nil]
    end

    describe "#small" do
      it "processes a small image with the following rules" do
        expect(@uploader.small.processors).to include [:resize_to_limit, [250, 150], nil]
      end
    end

    describe "#thumb" do
      it "processes a thumbnail with the following rules" do
        expect(@uploader.thumb.processors).to include [:resize_to_fit, [150, 75], nil]
      end
    end
  end
end

