require 'spec_helper'

describe PhotoUploader do

  before do
    @file = File.open(Rails.root.join("spec/data/images/photo.jpg"))
    @animal = Animal.gen
    @photo = Photo.gen :image => @file, :attachable => @animal
    @uploader = PhotoUploader.new @photo, :image
  end

  it "contains a processor for setting content type" do
    @uploader.processors.should include [:set_content_type, true, nil]
  end

  it "has storage set correctly" do
    PhotoUploader.storage.should == CarrierWave::Storage::Fog
  end

  describe "#extension_white_list" do
    it "has an extension white list" do
      @uploader.extension_white_list.should match_array(["jpg", "jpeg", "gif", "png"])
    end
  end

  describe '#default_url' do
    it "has a original default url" do
      @uploader.default_url.should == "/assets/default_original_photo.jpg"
    end

    it "specific default url version" do
      @uploader.large.default_url.should == "/assets/default_large_photo.jpg"
      @uploader.thumb.default_url.should == "/assets/default_thumb_photo.jpg"
    end
  end

  describe '#store_dir' do
    it "has a correct store directory" do
      @uploader.store_dir.should == "animals/photos/#{@photo.id}/original"
    end
  end

  describe '#full_filename' do
    it "sets the full filename" do
      @uploader.full_filename(@photo.image.file).should == @photo.image.file
    end
  end

  describe '#filename' do
    it "returns a customized filename" do
      @photo.image.filename.should == "#{@photo.guid}.jpg"
    end
  end

  context "after processing versions" do

    it "contains processor to resize to limit" do
      @uploader.processors.should include [:resize_to_limit, [800, 800], nil]
    end

    describe "#large" do
      it "processes a large image with the following rules" do
        @uploader.large.processors.should include [:resize_to_limit, [500, 400], nil]
      end
    end

    describe "#small" do
      it "processes a small image with the following rules" do
        @uploader.small.processors.should include [:resize_to_limit, [250, 150], nil]
      end
    end

    describe "#thumb" do
      it "processes a thumbnail with the following rules" do
        @uploader.thumb.processors.should include [:resize_to_fill, [100, 75, "North"], nil]
      end
    end

  end
end

