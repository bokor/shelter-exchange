require "rails_helper"

describe Comment do

  it "has a default scope" do
    expect(Comment.scoped.to_sql).to eq(Comment.order('comments.created_at DESC').to_sql)
  end

  it "requires presence of comment" do
    comment = Comment.gen :comment => nil
    expect(comment.error_on(:comment).size).to eq(1)
    expect(comment.errors[:comment]).to match_array(["cannot be blank"])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Comment, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    comment = Comment.new :shelter => shelter

    expect(comment.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    comment = Comment.gen
    expect(comment.reload.shelter).to be_readonly
  end
end

describe Comment, "#commentable" do

  it "belongs to a commentable object" do
    item = Item.new
    animal = Animal.new
    comment1 = Comment.new :commentable => item
    comment2 = Comment.new :commentable => animal

    expect(comment1.commentable).to eq(item)
    expect(comment1.commentable).to be_instance_of(Item)

    expect(comment2.commentable).to eq(animal)
    expect(comment2.commentable).to be_instance_of(Animal)
  end
end

describe Comment, "#commentable?" do

  it "returns true if the comment has an commentable association" do
    item = Item.new
    comment1 = Comment.new :commentable => item
    comment2 = Comment.new

    expect(comment1.commentable?).to eq(true)
    expect(comment2.commentable?).to eq(false)
  end
end

