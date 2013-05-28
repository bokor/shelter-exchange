FactoryGirl.define do

  factory :alert do
    title       "This is a new alert"
    description "Alert description"
    severity    Alert::SEVERITIES[0]
    stopped     false
    shelter
    created_at Time.now
    updated_at Time.now
  end
end

