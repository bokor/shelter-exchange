require "rails_helper"

describe Announcement do

  it "has a default scope" do
    expect(Announcement.scoped.to_sql).to eq(Announcement.order('announcements.created_at DESC').to_sql)
  end

  it "requires presence of title" do
    announcement = Announcement.new :title => nil
    expect(announcement.error_on(:title).size).to eq(1)
    expect(announcement.errors[:title]).to match_array(["cannot be blank"])
  end

  it "requires presence of message" do
    announcement = Announcement.new :title => nil
    expect(announcement.error_on(:title).size).to eq(1)
    expect(announcement.errors[:title]).to match_array(["cannot be blank"])
  end

  it "requires inclusion of category" do
    announcement = Announcement.new :category => "#{Announcement::CATEGORIES[0]} blah"
    expect(announcement.error_on(:category).size).to eq(1)
    expect(announcement.errors[:category]).to match_array(["needs to be selected"])
  end

  it "requires presence of starts at" do
    announcement = Announcement.new :starts_at => nil
    expect(announcement.error_on(:starts_at).size).to eq(1)
    expect(announcement.errors[:starts_at]).to match_array(["cannot be blank"])
  end

  it "requires presence of ends at" do
    announcement = Announcement.new :ends_at => nil
    expect(announcement.error_on(:ends_at).size).to eq(1)
    expect(announcement.errors[:ends_at]).to match_array(["cannot be blank"])
  end
end

# Constants
#----------------------------------------------------------------------------
describe Announcement, "::CATEGORIES" do
  it "contains a default list of Categories" do
    expect(Announcement::CATEGORIES).to match_array(["general", "web_update", "help"])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Announcement, ".active" do

  it "returns values that haven't passed the current_time" do
    Announcement.gen :starts_at => Time.now, :ends_at => Time.now + 10.hours
    Announcement.gen :starts_at => Time.now + 1.day, :ends_at => Time.now + 2.days

    announcements = Announcement.active(Time.now)
    expect(announcements.count).to eq(1)
  end
end

describe Announcement, ".since" do

  it "returns values that been updated or started" do
    Announcement.gen :starts_at => Time.now + 10.hours
    Announcement.gen :starts_at => Time.now

    announcements = Announcement.since(Time.now)
    expect(announcements.count).to eq(1)
  end
end

describe Announcement, ".current_announcements" do

  it "returns current announcemets that aren't hidden" do
    Announcement.gen :starts_at => Time.now, :ends_at => Time.now + 10.hours
    Announcement.gen :starts_at => Time.now + 1.day, :ends_at => Time.now + 2.days

    announcements = Announcement.current_announcements(Time.now - 1.hour)
    expect(announcements.count).to eq(1)
  end
end

