require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :transfer, :readonly => true

describe TransferHistory do

  it "should have a default scope" do
    default_scope :order => 'created_at DESC'
  end
end

describe TransferHistory, ".create_with" do
  def self.create_with(shelter_id, transfer_id, status, reason)
    create!(:shelter_id => shelter_id, :transfer_id => transfer_id, :status => status, :reason => reason)
  end
end

