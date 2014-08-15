require "spec_helper"

describe Contact do

  it_should_behave_like Geocodeable
  it_should_behave_like Uploadable

  it "has a default scope" do
    expect(Contact.scoped.to_sql).to eq(Contact.order("contacts.last_name ASC, contacts.first_name ASC").to_sql)
  end

  it "validates presence of first_name" do
    contact = Contact.new :first_name => nil, :last_name => nil
    expect(contact).to have(1).error_on(:first_name)
    expect(contact.errors[:first_name]).to match_array(["cannot be blank"])
  end

  it "validates presence of last_name" do
    contact = Contact.new :first_name => nil, :last_name => nil
    expect(contact).to have(1).error_on(:last_name)
    expect(contact.errors[:last_name]).to match_array(["cannot be blank"])
  end

  context "Before Save" do

    it "cleans the phone numbers to store without hyphens" do
      contact = Contact.gen(
        :phone => "123-456-7890",
        :mobile => "098-765-4321"
      )
      expect(contact.phone).to eq("1234567890")
      expect(contact.mobile).to eq("0987654321")
    end
  end

  context "Mount Uploader" do

    it "returns a photo uploader for the photo" do
      contact = Contact.gen
      expect(contact.photo).to be_kind_of(ContactPhotoUploader)
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Contact, "::ROLES" do
  it "contains a default list of roles" do
    expect(Contact::ROLES).to match_array([
      "adopter",
      "foster",
      "volunteer",
      "transporter",
      "donor",
      "staff",
      "veterinarian"
    ])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Contact, ".per_page" do
  it "returns the per page value for pagination" do
    expect(Contact.per_page).to eq(25)
  end
end

describe Contact, ".search" do

  before do
    @contact1 = Contact.gen(
      :first_name => "Jimmy",
      :last_name => "Smith",
      :email => "who@example.com",
      :phone => "123-456-7890",
      :state => "CA"
    )
    @contact2 = Contact.gen(
      :first_name => "The",
      :last_name => "Dude",
      :mobile => "666-777-8888",
      :state => "CA"
    )
  end

  it "returns search results based on phone" do
    contacts = Contact.search("123-456-7890")
    expect(contacts).to match_array([@contact1])
  end

  it "returns search results based on mobile" do
    contacts = Contact.search("666-777-8888")
    expect(contacts).to match_array([@contact2])
  end

  it "returns search results based on email" do
    contacts = Contact.search("who@example.com")
    expect(contacts).to match_array([@contact1])
  end

  it "returns search results based on first_name" do
    contacts = Contact.search("Jimmy")
    expect(contacts).to match_array([@contact1])
  end

  it "returns search results based on last_name" do
    contacts = Contact.search("dude")
    expect(contacts).to match_array([@contact2])
  end
end

describe Contact, ".filter_by_last_name_role" do

  before do
    @contact1 = Contact.gen :last_name => "A1", :adopter => "1", :foster => "0"
    @contact2 = Contact.gen :last_name => "A2", :adopter => "0", :foster => "1"
    @contact3 = Contact.gen :last_name => "B1", :adopter => "1", :foster => "0"
    @contact4 = Contact.gen :last_name => "B2", :adopter => "0", :foster => "1"
  end

  it "returns results for last name initial" do
    contacts = Contact.filter_by_last_name_role("A", "")
    expect(contacts).to match_array([@contact1, @contact2])
  end

  it "returns results for category" do
    contacts = Contact.filter_by_last_name_role("", "adopter")
    expect(contacts).to match_array([@contact1, @contact3])
  end

  it "returns results for last name initial and category" do
    contacts = Contact.filter_by_last_name_role("A", "adopter")
    expect(contacts).to match_array([@contact1])
  end
end

describe Contact, ".search_by_name" do

  it "returns a list of contacts based on the first name" do
    contact1 = Contact.gen :first_name => "jim"
    contact2 = Contact.gen :first_name => "jimmy"
    Contact.gen :first_name => "bob"

    contacts = Contact.search_by_name("jim")
    expect(contacts.count).to eq(2)
    expect(contacts).to match_array([contact1, contact2])
  end

  it "returns a list of contacts based on the last name" do
    contact1 = Contact.gen :last_name => "smith"
    contact2 = Contact.gen :last_name => "smithy"
    Contact.gen :last_name => "doe"

    contacts = Contact.search_by_name("smith")
    expect(contacts.count).to eq(2)
    expect(contacts).to match_array([contact1, contact2])
  end

  it "returns a list of contacts based on the first and last name" do
    contact1 = Contact.gen :first_name => "jim", :last_name => "smith"
    contact2 = Contact.gen :first_name => "jimmy", :last_name => "smithy"
    Contact.gen :first_name => "john", :last_name => "doe"

    contacts = Contact.search_by_name("jim smith")
    expect(contacts.count).to eq(2)
    expect(contacts).to match_array([contact1, contact2])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Contact, "#shelter" do

  it "belongs to an shelter" do
    shelter = Shelter.new
    contact = Contact.new :shelter => shelter

    expect(contact.shelter).to eq(shelter)
  end
end

describe Contact, "#notes" do

  before do
    @contact = Contact.gen
    @note1 = Note.gen :notable => @contact
    @note2 = Note.gen :notable => @contact
  end

  it "returns a list of notes" do
    expect(@contact.notes.count).to eq(2)
    expect(@contact.notes).to match_array([@note1, @note2])
  end

  it "destroy all notes associated to the contact" do
    expect(@contact.notes.count).to eq(2)
    @contact.destroy
    expect(@contact.notes.count).to eq(0)
  end
end

describe Contact, "#status_histories" do

  before do
    @contact = Contact.gen
    @status_history1 = StatusHistory.gen :contact => @contact
    @status_history2 = StatusHistory.gen :contact => @contact
  end

  it "returns a list of status histories" do
    expect(@contact.status_histories.count).to eq(2)
    expect(@contact.status_histories).to match_array([@status_history1, @status_history2])
  end

  it "returns a readonly status history" do
    expect(@contact.status_histories.first).to be_readonly
  end
end

describe Contact, "#name" do

  it "returns the name concatinated" do
    contact = Contact.new :first_name => "Jimmy", :last_name => "Smith"
    expect(contact.name).to eq("Jimmy Smith")
  end
end

