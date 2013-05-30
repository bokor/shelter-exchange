FactoryGirl.define do

  factory :transfer_history do
    status "This is a transfer history status"
    reason "This is a transfer reason"
    shelter
    transfer
  end
end

