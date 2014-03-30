FactoryGirl.define do

  factory :announcement do
    sequence(:title) {|n| "announcement title #{n}" }
    message "Announcement Message"
    category Announcement::CATEGORIES[0]
    starts_at Time.now - 5.minutes
    ends_at Time.now + 5.minutes
  end
end

