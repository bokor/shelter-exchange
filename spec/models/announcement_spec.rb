require "spec_helper"

describe Announcement do

  it "should have a default scope" do
pending "Need to implement"
    #default_scope :order => 'created_at DESC'
  end

  it "should require title" do
pending "Need to implement"
    #validates :title, :presence => true
  end

  it "should require message" do
pending "Need to implement"
    #validates :message, :presence => true
  end

  it "should require category" do
pending "Need to implement"
    #validates :category, :presence => { :in => CATEGORIES }
  end

  it "should require starts at" do
pending "Need to implement"
    #validates :starts_at, :presence => true
  end

  it "should require ends at" do
pending "Need to implement"
    #validates :ends_at, :presence => true
  end
end

describe Announcement, "::CATEGORIES" do
pending "Need to implement"
  it "should contain a default list of Categories" do
    #Announcement::CATEGORIES.should == ["general", "web_update", "help"]
  end
end

describe Announcement, ".active" do
pending "Need to implement"
  #scope :active, lambda { |current_time| where("starts_at <= ? AND ends_at >= ?", current_time, current_time) }
end

describe Announcement, ".since" do
pending "Need to implement"
  #scope :since, lambda { |hide_time| where("updated_at > ? OR starts_at > ?", hide_time.to_time.utc, hide_time.to_time.utc) if hide_time }
end

describe Announcement, ".current_announcements" do
pending "Need to implement"
  #def self.current_announcements(hide_time)
    #active(Time.now.utc).since(hide_time)
  #end
end

