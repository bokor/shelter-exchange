FactoryGirl.define do

  factory :account do
    #sequence(:subdomain) {|n| "subdomain#{n}" }
    subdomain "subdomain"
    document { File.new(Rails.root + 'spec/data/images/adoption_contract.jpg') }
    document_type 'Your adoption contract'
    users {|u| [u.association(:user)] }
    shelters {|s| [s.association(:shelter)] }
  end
end

