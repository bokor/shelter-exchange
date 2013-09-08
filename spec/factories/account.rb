FactoryGirl.define do

  factory :account do
    sequence(:subdomain) {|n| "subdomain#{n}" }
    document { File.new(Rails.root + 'spec/data/images/adoption_contract.jpg') }
    document_type 'Your adoption contract'

    after(:build) do |account|
      account.shelters << Shelter.gen(account: account) if account.shelters.size == 0
      account.users << User.gen(account: account, role: User::OWNER) if account.users.size == 0
    end
  end
end

