# require 'spec_helper'
#
# describe AttachmentUploader do
#
#   it "contains a processor for setting content type" do
#     AttachmentUploader.processors.should include [:set_content_type, true, nil]
#   end
#
#   it "has storage set correctly" do
#     AttachmentUploader.storage.should == CarrierWave::Storage::Fog
#   end
#
#   describe '#store_dir' do
#     it "has a correct store directory" do
#       @file = File.open(Rails.root.join("spec/data/documents/testing.pdf"))
#       @account = Account.gen :document => @file
#       @uploader = AttachmentUploader.new @account, :document
#       @uploader.store_dir.should == "accounts/documents/#{@account.id}/original"
#     end
#   end
# end
#
#
#
#
# require 'spec_helper'
#
# describe PhotoUploader do
#   include CarrierWave::Test::Matchers
#
#   before do
#     PhotoUploader.enable_processing = true
#     @iphone_file = File.open( Rails.root.join 'spec/fixtures/images/iphone.jpg' )
#     @image_file  = File.open( Rails.root.join 'spec/fixtures/images/precious.jpg' )
#     @photo       = Photo.gen
#     @uploader    = PhotoUploader.new @photo, :image
#   end
#
#   after do
#     PhotoUploader.enable_processing = false
#   end
#
#   context PhotoUploader, '#auto_rotate' do
#
#     it "should contain a processor for auto rotating" do
#       PhotoUploader.new.processors.should include [:auto_rotate, [], nil]
#     end
#
#     it "should rotate images based on EXIF orientation metadata" do
#       img_before = ::MiniMagick::Image::read(File.binread(@iphone_file))
#       img_before[:width].should == 320
#       img_before[:height].should == 240
#
#       @uploader.store! @iphone_file
#
#       img_after = ::MiniMagick::Image::read(File.binread(@uploader.file.file))
#       img_after[:width].should == 240
#       img_after[:height].should == 320
#     end
#
#     it "should not rotate images withough EXIF orientation metadata" do
#       img_before = ::MiniMagick::Image::read(File.binread(@image_file))
#       img_before[:width].should == 500
#       img_before[:height].should == 282
#
#       @uploader.store! @image_file
#
#       img_after = ::MiniMagick::Image::read(File.binread(@uploader.file.file))
#       img_after[:width].should == 500
#       img_after[:height].should == 282
#     end
#   end
#
#   context PhotoUploader, '#thumbnail' do
#
#     it 'generates a thumbnail' do
#       @uploader.store! @image_file
#       @uploader.thumbnail.should have_dimensions( 120, 120 )
#     end
#   end
#
#   context PhotoUploader, '#store_dir' do
#
#     before do
#       @uploader.store! @image_file
#     end
#
#     it 'stores images at the correct path' do
#       @uploader.store_dir.should == "uploads/photo/image/#{ @photo.id }"
#     end
#
#     it 'supports a blank namespace' do
#       Rails.configuration.fog[:namespace] = ''
#       @uploader.store_dir.should == "uploads/photo/image/#{ @photo.id }"
#       Rails.configuration.fog[:namespace] = nil
#       @uploader.store_dir.should == "uploads/photo/image/#{ @photo.id }"
#       Rails.configuration.fog[:namespace] = 'test' # reset back to test
#     end
#
#     it 'provides the correct url to images' do
#       @uploader.url.should           == "/uploads/photo/image/#{ @photo.id }/precious.jpg"
#       @uploader.thumbnail.url.should == "/uploads/photo/image/#{ @photo.id }/thumbnail_precious.jpg"
#     end
#   end
#
#   context PhotoUploader, '#extension_white_list' do
#
#     it 'only accepts jpg, jpeg, gif, and png files' do
#       PhotoUploader.new.extension_white_list.should == %w( jpg jpeg gif png )
#     end
#   end
# end
#
