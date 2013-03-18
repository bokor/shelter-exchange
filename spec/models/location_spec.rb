require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :readonly => true
# has_many :accommodations, :readonly => true
#
#
describe Location do

  it "should have a default scope" do
    #default_scope :order => 'name ASC'
  end

  it "should require name" do
    #validates :name, :presence => true
  end
end
