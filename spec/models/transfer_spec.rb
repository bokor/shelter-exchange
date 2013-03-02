require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :class_name => "Shelter", :readonly => true
# belongs_to :requestor_shelter, :class_name => "Shelter", :readonly => true
# belongs_to :animal
# has_many :transfer_histories, :dependent => :destroy
#
# after_save :create_transfer_history!, :transfer_animal_record!
    # def create_transfer_history!
    #   TransferHistory.create_with(self.shelter_id, self.id, self.status, @transfer_history_reason) unless @transfer_history_reason.blank?
    # end

    # def transfer_animal_record!
    #   self.animal.complete_transfer_request!(self.shelter, self.requestor_shelter) if self.completed?
    # end

#
# attr_accessor :transfer_history_reason

describe Transfer do

  it "should have a default scope" do
    default_scope :order => 'created_at DESC'
  end

  it "should require a requestor" do
    validates :requestor, :presence => true
  end

  it "should require a phone number" do
    validates :phone, :presence => true
  end

  it "should require an email address" do
    validates :email, :presence => true, :email_format => true
  end

  it "should validate that the email address is formatted correct" do
    validates :email, :presence => true, :email_format => true
  end

  it "should correctly validate transfer history reason when required" do
    # validates :transfer_history_reason, :presence => { :if => :transfer_history_reason_required? }
    #   def transfer_history_reason_required?
    #     self.rejected?
    #   end
  end
end

describe Transfer, "::APPROVED" do
  it "should return the correct value for the approved constant" do
    Transfer::APPROVED.should == "approved"
  end
end

describe Transfer, "::REJECTED" do
  it "should return the correct value for the rejected constant" do
    Transfer::REJECTED.should == "rejected"
  end
end

describe Transfer, "::COMPLETED" do
  it "should return the correct value for the completed constant" do
    Transfer::COMPLETED.should == "completed"
  end
end

describe Transfer, ".approved" do
  scope :approved, where(:status => APPROVED)
end

describe Transfer, ".rejected" do
  scope :rejected, where(:status => REJECTED)
end

describe Transfer, ".completed" do
  scope :completed, where(:status => COMPLETED)
end

describe Transfer, ".active" do
  scope :active, where("transfers.status IS NULL or transfers.status = ?", APPROVED)
end

describe Transfer, "#new_request?" do
  def new_request?
    self.status.blank?
  end
end

describe Transfer, "#approved?" do
  def approved?
    self.status == APPROVED
  end
end

describe Transfer, "#rejected?" do
  def rejected?
    self.status == REJECTED
  end
end

describe Transfer, "#completed?" do
  def completed?
    self.status == COMPLETED
  end
end

