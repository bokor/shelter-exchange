require 'spec_helper'

describe PhotoUploader do

  before do
    @file = File.open(Rails.root.join("spec/data/images/photo.jpg"))
    @animal = Animal.gen
    @photo = Photo.gen :image => @file, :attachable => @animal
    @uploader = PhotoUploader.new @photo, :image
  end

  it "contains a processor for setting content type" do
    expect(@uploader.processors).to include [:set_content_type, true, nil]
  end

  it "has storage set correctly" do
    expect(PhotoUploader.storage).to eq(CarrierWave::Storage::Fog)
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
      expect(@uploader.large.default_url).to eq("/assets/default_large_photo.jpg")
      expect(@uploader.thumb.default_url).to eq("/assets/default_thumb_photo.jpg")
    end
  end

  describe '#store_dir' do
    it "has a correct store directory" do
      expect(@uploader.store_dir).to eq("animals/photos/#{@photo.id}/original")
    end
  end

  describe '#full_filename' do
    it "sets the full filename" do
      expect(@uploader.full_filename(@photo.image.file)).to eq(@photo.image.file)
    end
  end

  describe '#filename' do
    it "returns a customized filename" do
      expect(@photo.image.filename).to eq("#{@photo.guid}.jpg")
    end
  end

  context "after processing versions" do

    it "contains processor to resize to limit" do
      expect(@uploader.processors).to include [:resize_to_limit, [800, 800], nil]
    end

    describe "#large" do
      it "processes a large image with the following rules" do
        expect(@uploader.large.processors).to include [:resize_to_limit, [500, 400], nil]
      end
    end

    describe "#small" do
      it "processes a small image with the following rules" do
        expect(@uploader.small.processors).to include [:resize_to_limit, [250, 150], nil]
      end
    end

    describe "#thumb" do
      it "processes a thumbnail with the following rules" do
        expect(@uploader.thumb.processors).to include [:resize_to_fill, [100, 75, "North"], nil]
      end
    end

  end
end

