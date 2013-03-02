require "spec_helper"

describe Announcement do

  it "should have a default scope" do
    default_scope :order => 'created_at DESC'
  end

  it "should require title" do
    validates :title, :presence => true
  end

  it "should require message" do
    validates :message, :presence => true
  end

  it "should require category" do
    validates :category, :presence => { :in => CATEGORIES }
  end

  it "should require starts at" do
    validates :starts_at, :presence => true
  end

  it "should require ends at" do
    validates :ends_at, :presence => true
  end
end

describe Announcement, "::CATEGORIES" do
  it "should contain a default list of Categories" do
    Announcement::CATEGORIES.should == ["general", "web_update", "help"]
  end
end

describe Announcement, ".active" do
  scope :active, lambda { |current_time| where("starts_at <= ? AND ends_at >= ?", current_time, current_time) }
end

describe Announcement, ".since" do
  scope :since, lambda { |hide_time| where("updated_at > ? OR starts_at > ?", hide_time.to_time.utc, hide_time.to_time.utc) if hide_time }
end

describe Announcement, ".current_announcements" do
  def self.current_announcements(hide_time)
    active(Time.now.utc).since(hide_time)
  end
end

