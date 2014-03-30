FactoryGirl.define do

  factory :document do
    document { Rack::Test::UploadedFile.new(Rails.root.join("spec/data/documents/testing.pdf")) }
    original_name "testing.pdf"
  end
end

