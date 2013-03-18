require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :readonly => true
# belongs_to :animal, :readonly => true
# belongs_to :parent, :readonly => true
#
# has_many :comments, :as => :commentable, :dependent => :destroy
#
# accepts_nested_attributes_for :comments, :allow_destroy => true, :reject_if => proc { |attributes| attributes['comment'].blank? }
#

describe Placement do

  it "should have a default scope" do
    #default_scope :order => 'created_at DESC'
  end

  it "should require an animal_id" do
    #validates :animal_id, :presence => {:message => 'needs to be selected'}
  end

  it "should require a status" do
    #validates :status, :presence => {:in => STATUS, :message => 'needs to be selected'}
  end
end

describe Placement, "::STATUS" do
  it "should contain a default list of statuses" do
    #Placement::STATUS = ["adopted", "foster_care"]
  end
end

describe Placement, ".adopted" do
  #scope :adopted, includes(:shelter, :animal => [:photos, :animal_type]).where(:status => "adopted")
end

describe Placement, ".foster_care" do
  #scope :foster_care, includes(:shelter, :animal => [:photos, :animal_type]).where(:status => "foster_care")
end

