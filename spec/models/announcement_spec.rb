require "spec_helper"

describe Announcement do

  it "should have a default scope" do
    Announcement.scoped.to_sql.should == Announcement.order('announcements.created_at DESC').to_sql
  end

  it "should require presence of title" do
    announcement = Announcement.new :title => nil
    announcement.should have(1).error_on(:title)
    announcement.errors[:title].should == ["cannot be blank"]
  end

  it "should require presence of message" do
    announcement = Announcement.new :title => nil
    announcement.should have(1).error_on(:title)
    announcement.errors[:title].should == ["cannot be blank"]
  end

  it "should require inclusion of category" do
    announcement = Announcement.new :category => "#{Announcement::CATEGORIES[0]} blah"
    announcement.should have(1).error_on(:category)
    announcement.errors[:category].should == ["needs to be selected"]
  end

  it "should require presence of starts at" do
    announcement = Announcement.new :starts_at => nil
    announcement.should have(1).error_on(:starts_at)
    announcement.errors[:starts_at].should == ["cannot be blank"]
  end

  it "should require presence of ends at" do
    announcement = Announcement.new :ends_at => nil
    announcement.should have(1).error_on(:ends_at)
    announcement.errors[:ends_at].should == ["cannot be blank"]
  end
end

# Constants
#----------------------------------------------------------------------------
describe Announcement, "::CATEGORIES" do
  it "should contain a default list of Categories" do
    Announcement::CATEGORIES.should == ["general", "web_update", "help"]
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Announcement, ".active" do

  it "should return values that haven't passed the current_time" do
    Announcement.gen :starts_at => Time.now, :ends_at => Time.now + 10.hours
    Announcement.gen :starts_at => Time.now + 1.day, :ends_at => Time.now + 2.days

    announcements = Announcement.active(Time.now)
    announcements.count.should == 1
  end
end

describe Announcement, ".since" do

  it "should return values that been updated or started" do
    Announcement.gen :starts_at => Time.now + 10.hours
    Announcement.gen :starts_at => Time.now

    announcements = Announcement.since(Time.now)
    announcements.count.should == 1
  end
end

describe Announcement, ".current_announcements" do

  it "should return current announcemets that aren't hidden" do
    Announcement.gen :starts_at => Time.now, :ends_at => Time.now + 10.hours
    Announcement.gen :starts_at => Time.now + 1.day, :ends_at => Time.now + 2.days

    announcements = Announcement.current_announcements(Time.now - 1.hour)
    announcements.count.should == 1
  end
end

