FactoryGirl.define do
  
  factory :shelter do
    name            'Shelter Exchange Test Shelter'
    phone           '999-999-9999'
    sequence(:email) {|n| "shelter#{n}@example.com" }
    website         'http://www.shelterexchange.org'
    twitter         '@shelterexchange'
    facebook        'http://www.facebook.com/shelterexchange'
    street          '730 Bair Island Rd'
    street_2        'Apt 101'
    city            'Redwood City'
    state           'CA'
    zip_code        '94063'
    time_zone       'Pacific Time (US & Canada)'
    status          'active'
    is_kill_shelter false
  end

end