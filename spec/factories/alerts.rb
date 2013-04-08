FactoryGirl.define do

  factory :alert do
    title       "This is a new alert"
    description "Alert description"
    severity    Alert::SEVERITIES[0]
    stopped     false
    shelter
  end
end

