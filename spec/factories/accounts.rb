FactoryGirl.define do

  factory :account do
    sequence(:subdomain) {|n| "subdomain#{n}" }
    document { File.new(Rails.root + 'spec/data/images/adoption_contract.jpg') }
    document_type 'Your adoption contract'
    users {|u| [u.association(:user)] }
    shelters {|s| [s.association(:shelter)] }
    created_at Time.now
    updated_at Time.now
  end
end

