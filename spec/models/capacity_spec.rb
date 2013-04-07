require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :readonly => true
# belongs_to :animal_type, :readonly => true
#

describe Capacity do

  it "should require a animal type" do
pending "Need to implement"
    #validates :animal_type_id, :presence => { :message => "needs to be selected" },
                             #:uniqueness => { :scope => :shelter_id, :message => "is already in use" }
  end

  it "should have a unique animal type per shelter" do
pending "Need to implement"
    #validates :animal_type_id, :presence => { :message => "needs to be selected" },
                             #:uniqueness => { :scope => :shelter_id, :message => "is already in use" }
  end

  it "should validate a numerical value for max capacity" do
pending "Need to implement"
    #validates :max_capacity, :numericality => true
  end
end

describe Capacity, "#animal_count" do
pending "Need to implement"
  #def animal_count(current_shelter)
    #self.animal_type.animals.active.where(:shelter_id => current_shelter).limit(nil).count
  #end
end

