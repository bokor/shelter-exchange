require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
#belongs_to :shelter, :readonly => true
#belongs_to :alertable, :polymorphic => true

describe Alert do

  it "should have a default scope" do
    default_scope :order => 'created_at DESC'
  end

  it "should require title" do
    validates :title, :presence => true
  end

  it "should require severity" do
    validates :severity, :presence => {:message => 'needs to be selected'}
  end
end

describe Alert, "::SEVERITIES" do
  it "should contain a default list of severities" do
    Alert::SEVERITIES.should == ["high", "medium", "low"]
  end
end

describe Alert, ".active" do
  scope :active, where(:stopped => false)
end

describe Alert, ".stopped" do
  scope :stopped, where(:stopped => true)
end

describe Alert, ".with_alertable" do
  scope :with_alertable, includes(:alertable)
end

describe Alert, ".for_shelter" do
  scope :for_shelter, where(:alertable_type => nil)
end

describe Alert, ".for_animals" do
  scope :for_animals, with_alertable.where(:alertable_type => Animal)
end

describe Alert, ".recent_activity" do
  def self.recent_activity(limit=10)
    with_alertable.reorder("alerts.updated_at DESC").limit(limit)
  end
end

describe Alert, "#stopped?" do
  def stopped?
    self.stopped
  end
end

describe Alert, "#active?" do
  def active?
    !self.stopped
  end
end

describe Alert, "#alertable?" do
  def alertable?
    !!self.alertable
  end
end

