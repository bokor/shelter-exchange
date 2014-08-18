require "spec_helper"

describe Parent do

  it "has a default scope" do
    expect(Parent.scoped.to_sql).to eq(Parent.order("parents.created_at DESC").to_sql)
  end

  it "validates presence of first_name" do
    parent = Parent.new :first_name => nil
    expect(parent).to have(1).error_on(:first_name)
    expect(parent.errors[:first_name]).to match_array(["cannot be blank"])
  end

  it "validates presence of last_name" do
    parent = Parent.new :last_name => nil
    expect(parent).to have(1).error_on(:last_name)
    expect(parent.errors[:last_name]).to match_array(["cannot be blank"])
  end

  it "validates presence of phone" do
    parent = Parent.new :phone => nil
    expect(parent).to have(1).error_on(:phone)
    expect(parent.errors[:phone]).to match_array(["cannot be blank"])
  end

  it "validates uniqueness of phone" do
    Parent.gen(:phone => "9999999999")
    parent = Parent.new :phone => "9999999999"
    expect(parent).to have(1).error_on(:phone)
    expect(parent.errors[:phone]).to match_array(["has already been taken"])
  end

  it "validates format of phone" do
    parent = Parent.new :phone => "aaa"
    expect(parent).to have(1).error_on(:phone)
    expect(parent.errors[:phone]).to match_array(["invalid phone number format"])

    parent = Parent.new :phone => "+011.999.00000"
    expect(parent).to have(1).error_on(:phone)
    expect(parent.errors[:phone]).to match_array(["invalid phone number format"])
  end

  it "validates uniqueness of mobile" do
    Parent.gen :mobile => "9999999999"
    parent = Parent.new :mobile => "9999999999"
    expect(parent).to have(1).error_on(:mobile)
    expect(parent.errors[:mobile]).to match_array(["has already been taken"])
  end

  it "validates format of mobile" do
    parent = Parent.new :mobile => "aaa"
    expect(parent).to have(1).error_on(:mobile)
    expect(parent.errors[:mobile]).to match_array(["invalid phone number format"])

    parent = Parent.new :mobile => "+011.999.00000"
    expect(parent).to have(1).error_on(:mobile)
    expect(parent.errors[:mobile]).to match_array(["invalid phone number format"])
  end

  it "validates allows blank for mobile" do
    parent = Parent.new :mobile => nil
    expect(parent).to have(0).error_on(:mobile)
  end

  it "validates uniqueness of email" do
    Parent.gen :email => "test@test.com"
    parent = Parent.new :email => "test@test.com"
    expect(parent).to have(1).error_on(:email)
    expect(parent.errors[:email]).to match_array(["There is an existing Parent associated with these details, please use the 'Look up' to locate the record."])
  end

  it "validates format of email" do
    parent = Parent.new :email => "blah.com"
    expect(parent).to have(1).error_on(:email)
    expect(parent.errors[:email]).to match_array(["format is incorrect"])
  end

  it "validates allows blank of email" do
    parent = Parent.new :email => nil
    expect(parent).to have(0).error_on(:email)
  end

  it "validates uniqueness of email_2" do
    Parent.gen :email_2 => "test@test.com"
    parent = Parent.new :email_2 => "test@test.com"
    expect(parent).to have(1).error_on(:email_2)
    expect(parent.errors[:email_2]).to match_array(["There is an existing Parent associated with these details, please use the 'Look up' to locate the record."])
  end

  it "validates format of email_2" do
    parent = Parent.new :email_2 => "test@test"
    expect(parent).to have(1).error_on(:email_2)
    expect(parent.errors[:email_2]).to match_array(["format is incorrect"])
  end

  it "validates allows blank of email_2" do
    parent = Parent.new :email_2 => nil
    expect(parent).to have(0).error_on(:email_2)
  end

  context "Before Save" do

    describe "#clean_phone_numbers" do

      it "cleans the phone numbers to store without hyphens" do
        parent = Parent.gen(
          :phone => "123-456-7890",
          :mobile => "098-765-4321"
        )
        expect(parent.phone).to eq("1234567890")
        expect(parent.mobile).to eq("0987654321")
      end
    end
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Parent, ".search" do

  before do
    @parent1 = Parent.gen(
      :first_name => "Jimmy",
      :last_name => "Smith",
      :email => "who@example.com",
      :phone => "123-456-7890",
      :state => "CA"
    )
    @parent2 = Parent.gen(
      :first_name => "The",
      :last_name => "Dude",
      :email_2 => "thedude@example.com",
      :mobile => "666-777-8888",
      :state => "CA"
    )
  end

  it "returns search results based on phone or mobile" do
    parents = Parent.search("123-456-7890")
    expect(parents).to match_array([@parent1])

    parents = Parent.search("666-777-8888")
    expect(parents).to match_array([@parent2])
  end

  it "returns search results based on email, email_2, or name" do
    parents = Parent.search("who@example.com")
    expect(parents).to match_array([@parent1])

    parents = Parent.search("dude")
    expect(parents).to match_array([@parent2])
  end

  it "returns search results based with state params" do
    parent = Parent.gen(
      :first_name => "the",
      :last_name => "duder",
      :email => "theduder@example.com",
      :state => "NV"
    )

    parents = Parent.search("dude", { :state => "NV" })
    expect(parents).to match_array([parent])

    parents = Parent.search("dude", { :state => "CA" })
    expect(parents).to match_array([@parent2])

    parents = Parent.search("thedude@example.com", { :state => "NV" })
    expect(parents).to match_array([])

    parents = Parent.search("thedude@example.com", { :state => "CA" })
    expect(parents).to match_array([@parent2])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Parent, "#name" do

  it "returns name" do
    parent = Parent.gen :first_name => "Billy", :last_name => "Smith"
    expect(parent.name).to eq("Billy Smith")
  end
end

describe Parent, "#notes" do

  before do
    @parent = Parent.gen
    @note1 = Note.gen :notable => @parent
    @note2 = Note.gen :notable => @parent
  end

  it "returns a list of notes" do
    expect(@parent.notes.count).to eq(2)
    expect(@parent.notes).to match_array([@note1, @note2])
  end

  it "destroy all notes associated to the parent" do
    expect(@parent.notes.count).to eq(2)
    @parent.destroy
    expect(@parent.notes.count).to eq(0)
  end
end

