FactoryGirl.define do

  factory :photo do
    image { File.open(Rails.root.join("spec/data/images/photo.jpg")) }
    is_main_photo true
  end
end

