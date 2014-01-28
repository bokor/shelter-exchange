require 'spec_helper'

describe LogoUploader do

  before do
    @file = File.open(Rails.root.join("spec/data/images/photo.jpg"))
    @shelter = Shelter.gen :logo => @file
    @uploader = LogoUploader.new @shelter, :logo
  end

  it "contains a processor for setting content type" do
    @uploader.processors.should include [:set_content_type, true, nil]
  end

  it "has storage set correctly" do
    LogoUploader.storage.should == CarrierWave::Storage::Fog
  end

  describe "#extension_white_list" do
    it "has an extension white list" do
      @uploader.extension_white_list.should match_array(["jpg", "jpeg", "gif", "png"])
    end
  end

  describe '#default_url' do
    it "has a original default url" do
      @uploader.default_url.should == "/assets/default_original_logo.jpg"
    end

    it "specific default url version" do
      @uploader.small.default_url.should == "/assets/default_small_logo.jpg"
      @uploader.thumb.default_url.should == "/assets/default_thumb_logo.jpg"
    end
  end

  describe '#store_dir' do
    it "has a correct store directory" do
      @uploader.store_dir.should == "shelters/logos/#{@shelter.id}/original"
    end
  end

  describe '#full_filename' do
    it "sets the full filename" do
      @uploader.full_filename(@shelter.logo.file).should == @shelter.logo.file
    end
  end

  describe '#filename' do
    it "returns a customized filename" do
      @shelter.logo.filename.should == "#{@shelter.guid}.jpg"
    end
  end

  context "after processing versions" do

    it "contains processor to resize to limit" do
      @uploader.processors.should include [:resize_to_limit, [500, 500], nil]
    end

    describe "#small" do
      it "processes a small image with the following rules" do
        @uploader.small.processors.should include [:resize_to_limit, [250, 150], nil]
      end
    end

    describe "#thumb" do
      it "processes a thumbnail with the following rules" do
        @uploader.thumb.processors.should include [:resize_to_fit, [150, 75], nil]
      end
    end

  end
end

