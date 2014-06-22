FactoryGirl.define do

  factory :document do
    document { Rack::Test::UploadedFile.new(Rails.root.join("spec/data/documents/testing.pdf")) }
  end
end

