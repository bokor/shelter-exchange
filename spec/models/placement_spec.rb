require "spec_helper"

describe Placement do

  it "has a default scope" do
    expect(Placement.scoped.to_sql).to eq(Placement.order('placements.created_at DESC').to_sql)
  end

  it "requires presence of animal id" do
    placement = Placement.new :animal_id => nil
    expect(placement).to have(1).error_on(:animal_id)
    expect(placement.errors[:animal_id]).to match_array(["needs to be selected"])
  end

  it "requires inclusion of status" do
    placement = Placement.new :status => "#{Placement::STATUS[0]} blah"
    expect(placement).to have(1).error_on(:status)
    expect(placement.errors[:status]).to match_array(["needs to be selected"])
  end

  context "Nested Attributes" do

    it "accepts nested attributes for comments" do
      expect(Placement.count).to eq(0)
      expect(Comment.count).to   eq(0)

      Placement.gen :comments_attributes => [{:comment => "placement comment"}]

      expect(Placement.count).to eq(1)
      expect(Comment.count).to   eq(1)
    end

    it "rejects nested attributes for comments" do
      expect(Placement.count).to eq(0)
      expect(Comment.count).to   eq(0)

      Placement.gen :comments_attributes => [{:comment => nil}]

      expect(Placement.count).to eq(1)
      expect(Comment.count).to   eq(0)
    end

    it "destroys nested comments" do
      placement = Placement.gen :comments_attributes => [{:comment => "destroy comment"}]

      expect(Placement.count).to eq(1)
      expect(Comment.count).to   eq(1)

      placement.destroy

      expect(Placement.count).to eq(0)
      expect(Comment.count).to   eq(0)
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Placement, "::STATUS" do
  it "contains a default list of statuses" do
    expect(Placement::STATUS).to match_array(["adopted", "foster_care"])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Placement, ".adopted" do

  it "returns all of the adopted placements" do
    placement1 = Placement.gen :status => "adopted"
    Placement.gen :status => "other"

    placements = Placement.adopted.all

    expect(placements.count).to eq(1)
    expect(placements).to match_array([placement1])
  end
end

describe Placement, ".foster_care" do

  it "returns all of the foster care placements" do
    placement1 = Placement.gen :status => "foster_care"
    Placement.gen :status => "other"

    placements = Placement.foster_care.all

    expect(placements.count).to eq(1)
    expect(placements).to match_array([placement1])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Placement, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    placement = Placement.new :shelter => shelter

    expect(placement.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    placement = Placement.gen
    expect(placement.reload.shelter).to be_readonly
  end
end

describe Placement, "#animal" do

  it "belongs to a animal" do
    animal = Animal.new
    placement = Placement.new :animal => animal

    expect(placement.animal).to eq(animal)
  end

  it "returns a readonly animal" do
    placement = Placement.gen
    expect(placement.reload.animal).to be_readonly
  end
end

describe Placement, "#parent" do

  it "belongs to a parent" do
    parent = Parent.new
    placement = Placement.new :parent => parent

    expect(placement.parent).to eq(parent)
  end

  it "returns a readonly parent" do
    placement = Placement.gen
    expect(placement.reload.parent).to be_readonly
  end
end

describe Placement, "#comments" do

  before do
    @placement = Placement.gen
    @comment1 = Comment.gen :commentable => @placement
    @comment2 = Comment.gen :commentable => @placement
  end

  it "returns a list of comments" do
    expect(@placement.comments.count).to eq(2)
    expect(@placement.comments).to match_array([@comment1, @comment2])
  end

  it "destroys the comments when a placement is deleted" do
    expect(@placement.comments.count).to eq(2)
    @placement.destroy
    expect(@placement.comments.count).to eq(0)
  end
end

