require "spec_helper"

describe Placement do

  it "has a default scope" do
    Placement.scoped.to_sql.should == Placement.order('placements.created_at DESC').to_sql
  end

  it "requires presence of animal id" do
    placement = Placement.new :animal_id => nil
    placement.should have(1).error_on(:animal_id)
    placement.errors[:animal_id].should == ["needs to be selected"]
  end

  it "requires inclusion of status" do
    placement = Placement.new :status => "#{Placement::STATUS[0]} blah"
    placement.should have(1).error_on(:status)
    placement.errors[:status].should == ["needs to be selected"]
  end

  context "Nested Attributes" do

    it "accepts nested attributes for comments" do
      Placement.count.should == 0
      Comment.count.should   == 0

      Placement.gen :comments_attributes => [{:comment => "placement comment"}]

      Placement.count.should == 1
      Comment.count.should   == 1
    end

    it "rejects nested attributes for comments" do
      Placement.count.should == 0
      Comment.count.should   == 0

      Placement.gen :comments_attributes => [{:comment => nil}]

      Placement.count.should == 1
      Comment.count.should   == 0
    end

    it "destroys nested comments" do
      placement = Placement.gen :comments_attributes => [{:comment => "destroy comment"}]

      Placement.count.should == 1
      Comment.count.should   == 1

      placement.destroy

      Placement.count.should == 0
      Comment.count.should   == 0
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Placement, "::STATUS" do
  it "contains a default list of statuses" do
    Placement::STATUS.should == ["adopted", "foster_care"]
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Placement, ".adopted" do

  it "returns all of the adopted placements" do
    placement1 = Placement.gen :status => "adopted"
    placement2 = Placement.gen :status => "other"

    placements = Placement.adopted.all

    placements.count.should == 1
    placements.should       == [placement1]
  end
end

describe Placement, ".foster_care" do

  it "returns all of the foster care placements" do
    placement1 = Placement.gen :status => "foster_care"
    placement2 = Placement.gen :status => "other"

    placements = Placement.foster_care.all

    placements.count.should == 1
    placements.should       == [placement1]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Placement, "#shelter" do

  it "belongs to a shelter" do
    shelter   = Shelter.new
    placement = Placement.new :shelter => shelter

    placement.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    placement = Placement.gen
    placement.reload.shelter.should be_readonly
  end
end

describe Placement, "#animal" do

  it "belongs to a animal" do
    animal    = Animal.new
    placement = Placement.new :animal => animal

    placement.animal.should == animal
  end

  it "returns a readonly animal" do
    placement = Placement.gen
    placement.reload.animal.should be_readonly
  end
end

describe Placement, "#parent" do

  it "belongs to a parent" do
    parent    = Parent.new
    placement = Placement.new :parent => parent

    placement.parent.should == parent
  end

  it "returns a readonly parent" do
    placement = Placement.gen
    placement.reload.parent.should be_readonly
  end
end

describe Placement, "#comments" do

  before do
    @placement = Placement.gen
    @comment1  = Comment.gen :commentable => @placement
    @comment2  = Comment.gen :commentable => @placement
  end

  it "returns a list of comments" do
    @placement.comments.count.should == 2
    @placement.comments.should       =~ [@comment1, @comment2]
  end

  it "destroys the comments when a placement is deleted" do
    @placement.comments.count.should == 2
    @placement.destroy
    @placement.comments.count.should == 0
  end
end

