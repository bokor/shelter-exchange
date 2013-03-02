require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# has_many :animals, :readonly => true
# has_many :breeds, :readonly => true
# has_many :accommodations, :readonly => true
# has_many :capacities, :readonly => true
#
describe AnimalType, "::TYPES" do
  it "should contain a default list of types" do
    AnimalType::TYPES.should == {
      :dog     => 1,
      :cat     => 2,
      :horse   => 3,
      :rabbit  => 4,
      :bird    => 5,
      :reptile => 6,
      :other   => 7
    }
  end
end

describe AnimalType, ".available_for_adoption_types" do
  scope :available_for_adoption_types, lambda { |shelter_id| joins(:animals).select("distinct animal_types.name").where("animals.shelter_id = ?", shelter_id).where("animals.animal_status_id" => AnimalStatus::STATUSES[:available_for_adoption]).order("animal_types.id") }
end

