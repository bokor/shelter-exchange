FactoryGirl.define do

  factory :transfer_history do
    status "This is a transfer history status"
    reason "This is a transfer reason"
    shelter
    transfer
    created_at Time.now
    updated_at Time.now
  end
end

