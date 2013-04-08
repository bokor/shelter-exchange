require "spec_helper"

describe Comment do

  it "should have a default scope" do
    Comment.scoped.to_sql.should == Comment.order('comments.created_at DESC').to_sql
  end

  it "should require presence of comment" do
    comment = Comment.gen :comment => nil
    comment.should have(1).error_on(:comment)
    comment.errors[:comment].should == ["cannot be blank"]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Comment, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.new
    comment = Comment.new :shelter => shelter

    comment.shelter.should == shelter
  end

  it "should return a readonly shelter" do
    comment = Comment.gen
    comment.reload.shelter.should be_readonly
  end
end

describe Comment, "#commentable" do

  it "should belong to a commentable object" do
    item    = Item.new
    animal  = Animal.new
    comment1 = Comment.new :commentable => item
    comment2 = Comment.new :commentable => animal

    comment1.commentable.should == item
    comment1.commentable.should be_instance_of(Item)

    comment2.commentable.should == animal
    comment2.commentable.should be_instance_of(Animal)
  end
end

describe Comment, "#commentable?" do

  it "should validate if the comment has an commentable association" do
    item     = Item.new
    comment1 = Comment.new :commentable => item
    comment2 = Comment.new

    comment1.commentable?.should == true
    comment2.commentable?.should == false
  end
end
