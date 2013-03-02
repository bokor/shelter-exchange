require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :readonly => true
# belongs_to :animal_type, :readonly => true
# belongs_to :location, :readonly => true

# has_many :animals, :readonly => true

describe Accommodation do

  it "should have a default scope" do
    default_scope :order => 'name ASC'
  end

  it "should require a animal type" do
    validates :animal_type_id, :presence => {:message => "needs to be selected"}
  end

  it "should require a name of the accommodation" do
    validates :name, :presence => true
  end

  it "should validate a numerical value for max capacity" do
    validates :max_capacity, :numericality => true
  end
end

describe Accommodation, ".per_page" do
  it "should return the per page value for pagination" do
    Accommodation.per_page.should == 50
  end
end

# From Accommodation::Searchable
describe Accommodation, ".search" do
  scope :search, lambda { |q| includes(:animal_type, :location, :animals => [:photos, :animal_status]).where("name LIKE ?", "%#{q}%") }
end

describe Accommodation, ".filter_by_type_location" do
  def filter_by_type_location(type, location)
    scope = scoped{}
    scope = scope.includes(:animal_type, :location, :animals => [:photos, :animal_status])
    scope = scope.where(:animal_type_id => type) unless type.blank?
    scope = scope.where(:location_id => location) unless location.blank?
    scope
  end
end

