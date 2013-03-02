require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :readonly => true
# belongs_to :commentable, :polymorphic => true
#
#
describe Note do

  it "should have a default scope" do
    default_scope :order => 'created_at DESC'
  end

  it "should require comment" do
    validates :comment, :presence => true
  end
end

describe Note, "#commentable?" do
  def commentable?
    !!self.commentable
  end
end
