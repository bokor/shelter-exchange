FactoryGirl.define do

  factory :photo do
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/data/images/photo.jpg")) }
    is_main_photo true
  end
end

