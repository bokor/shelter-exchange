FactoryGirl.define do

  factory :setting do
    shelter
    animal_type
    adoption_contract { File.new(Rails.root + 'spec/data/images/adoption_contract.jpg') }
  end
end
