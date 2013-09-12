require "spec_helper"

describe Parent do

  it_should_behave_like StreetAddressable

  it "has a default scope" do
    Parent.scoped.to_sql.should == Parent.order("parents.created_at DESC").to_sql
  end

  it "validates presence of name" do
    parent = Parent.new :name => nil
    parent.should have(1).error_on(:name)
    parent.errors[:name].should == ["cannot be blank"]
  end

  it "validates presence of phone" do
    parent = Parent.new :phone => nil
    parent.should have(1).error_on(:phone)
    parent.errors[:phone].should == ["cannot be blank"]
  end

  it "validates uniqueness of phone" do
    Parent.gen(:phone => "9999999999")
    parent = Parent.new :phone => "9999999999"
    parent.should have(1).error_on(:phone)
    parent.errors[:phone].should == ["has already been taken"]
  end

  it "validates format of phone" do
    parent = Parent.new :phone => "aaa"
    parent.should have(1).error_on(:phone)
    parent.errors[:phone].should == ["invalid phone number format"]

    parent = Parent.new :phone => "+011.999.00000"
    parent.should have(1).error_on(:phone)
    parent.errors[:phone].should == ["invalid phone number format"]
  end

  it "validates uniqueness of mobile" do
    Parent.gen :mobile => "9999999999"
    parent = Parent.new :mobile => "9999999999"
    parent.should have(1).error_on(:mobile)
    parent.errors[:mobile].should == ["has already been taken"]
  end

  it "validates format of mobile" do
    parent = Parent.new :mobile => "aaa"
    parent.should have(1).error_on(:mobile)
    parent.errors[:mobile].should == ["invalid phone number format"]

    parent = Parent.new :mobile => "+011.999.00000"
    parent.should have(1).error_on(:mobile)
    parent.errors[:mobile].should == ["invalid phone number format"]
  end

  it "validates allows blank for mobile" do
    parent = Parent.new :mobile => nil
    parent.should have(0).error_on(:mobile)
  end

  it "validates uniqueness of email" do
    Parent.gen :email => "test@test.com"
    parent = Parent.new :email => "test@test.com"
    parent.should have(1).error_on(:email)
    parent.errors[:email].should == ["There is an existing Parent associated with these details, please use the 'Look up' to locate the record."]
  end

  it "validates format of email" do
    parent = Parent.new :email => "blah.com"
    parent.should have(1).error_on(:email)
    parent.errors[:email].should == ["format is incorrect"]
  end

  it "validates allows blank of email" do
    parent = Parent.new :email => nil
    parent.should have(0).error_on(:email)
  end

  it "validates uniqueness of email_2" do
    Parent.gen :email_2 => "test@test.com"
    parent = Parent.new :email_2 => "test@test.com"
    parent.should have(1).error_on(:email_2)
    parent.errors[:email_2].should == ["There is an existing Parent associated with these details, please use the 'Look up' to locate the record."]
  end

  it "validates format of email_2" do
    parent = Parent.new :email_2 => "test@test"
    parent.should have(1).error_on(:email_2)
    parent.errors[:email_2].should == ["format is incorrect"]
  end

  it "validates allows blank of email_2" do
    parent = Parent.new :email_2 => nil
    parent.should have(0).error_on(:email_2)
  end

  context "Before Save" do

    it "cleans the phone numbers to store without hyphens" do
      parent = Parent.gen(
        :phone => "123-456-7890",
        :mobile => "098-765-4321"
      )
      parent.phone.should == "1234567890"
      parent.mobile.should == "0987654321"
    end
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Parent, ".search" do

  before do
    @parent1 = Parent.gen(
      :name => "Jimmy",
      :email => "who@example.com",
      :phone => "123-456-7890",
      :state => "CA"
    )
    @parent2 = Parent.gen(
      :name => "The Dude",
      :email_2 => "thedude@example.com",
      :mobile => "666-777-8888",
      :state => "CA"
    )
  end

  it "returns search results based on phone or mobile" do
    parents = Parent.search("123-456-7890")
    parents.should =~ [@parent1]

    parents = Parent.search("666-777-8888")
    parents.should =~ [@parent2]
  end

  it "returns search results based on email, email_2, or name" do
    parents = Parent.search("who@example.com")
    parents.should =~ [@parent1]

    parents = Parent.search("dude")
    parents.should =~ [@parent2]
  end

  it "returns search results based with state params" do
    parent = Parent.gen(
      :name => "the duder",
      :email => "theduder@example.com",
      :state => "NV"
    )

    parents = Parent.search("dude", { :state => "NV" })
    parents.should =~ [parent]

    parents = Parent.search("dude", { :state => "CA" })
    parents.should =~ [@parent2]

    parents = Parent.search("thedude@example.com", { :state => "NV" })
    parents.should =~ []

    parents = Parent.search("thedude@example.com", { :state => "CA" })
    parents.should =~ [@parent2]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Parent, "#placements" do

  before do
    @parent = Parent.gen
    @placement1 = Placement.gen :parent => @parent
    @placement2 = Placement.gen :parent => @parent
  end

  it "returns a list of placements" do
    @parent.placements.count.should == 2
    @parent.placements.should =~ [@placement1, @placement2]
  end

  it "destroy all placements associated to the parent" do
    @parent.placements.count.should == 2
    @parent.destroy
    @parent.placements.count.should == 0
  end
end

describe Parent, "#animals" do

  before do
    @parent = Parent.gen
    @animal1 = Animal.gen
    @animal2 = Animal.gen

    Placement.gen :parent => @parent, :animal => @animal1
    Placement.gen :parent => @parent, :animal => @animal2
  end

  it "returns a list of animals" do
    @parent.animals.count.should == 2
    @parent.animals.should =~ [@animal1, @animal2]
  end
end

describe Parent, "#shelters" do

  before do
    @parent = Parent.gen
    @shelter1 = Shelter.gen
    @shelter2 = Shelter.gen

    Placement.gen :parent => @parent, :shelter => @shelter1
    Placement.gen :parent => @parent, :shelter => @shelter2
  end

  it "returns a list of shelters" do
    @parent.shelters.count.should == 2
    @parent.shelters.should =~ [@shelter1, @shelter2]
  end
end

describe Parent, "#notes" do

  before do
    @parent = Parent.gen
    @note1 = Note.gen :notable => @parent
    @note2 = Note.gen :notable => @parent
  end

  it "returns a list of notes" do
    @parent.notes.count.should == 2
    @parent.notes.should =~ [@note1, @note2]
  end

  it "destroy all notes associated to the parent" do
    @parent.notes.count.should == 2
    @parent.destroy
    @parent.notes.count.should == 0
  end
end

