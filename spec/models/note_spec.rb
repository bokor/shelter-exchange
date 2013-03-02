require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :readonly => true
# belongs_to :notable, :polymorphic => true
#
#
describe Note do

  it "should have a default scope" do
    default_scope :order => 'created_at DESC'
  end

  it "should require a title" do
    validates :title, :presence => true
  end

  it "should require a category" do
    validates :category, :presence => { :in => CATEGORIES, :message => "needs to be selected" }
  end
end

describe Note, "::DEFAULT_CATEGORY" do
  it "should contain a single value for the default category" do
    Note::DEFAULT_CATEGORY.should == "general"
  end
end

describe Note, "::CATEGORIES" do
  it "should contain a default list of Categories" do
    Note::CATEGORIES.should == ["general", "medical", "behavioral", "intake"]
  end
end

describe Note, "#notable?" do
  def notable?
    !!self.notable
  end
end

