FactoryGirl.define do

  factory :document do
    document { File.open(Rails.root.join("spec/data/documents/testing.pdf")) }
  end
end

