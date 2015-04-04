require "rails_helper"

describe Contact do

  it_should_behave_like Geocodeable
  it_should_behave_like Uploadable

  it "has a default scope" do
    expect(Contact.scoped.to_sql).to eq(Contact.order("contacts.last_name ASC, contacts.first_name ASC").to_sql)
  end

  it "validates presence of first_name" do
    contact = Contact.new :first_name => nil, :last_name => nil

    expect(contact.valid?).to be_falsey
    expect(contact.errors[:first_name].size).to eq(1)
    expect(contact.errors[:first_name]).to match_array(["cannot be blank"])
  end

  it "validates presence of last_name" do
    contact = Contact.new :first_name => nil, :last_name => nil

    expect(contact.valid?).to be_falsey
    expect(contact.errors[:last_name].size).to eq(1)
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

# Class Methods
#----------------------------------------------------------------------------
describe Contact, ".per_page" do
  it "returns the per page value for pagination" do
    expect(Contact.per_page).to eq(25)
  end
end



describe Contact, ".search_and_filter" do

  before do
    @contact1 = Contact.gen(
      :first_name => "Jimmy",
      :last_name => "Smith",
      :company_name => "Shelter Exchange, Inc",
      :email => "who@example.com",
      :phone => "123-456-7890",
      :city => "Redwood City",
      :state => "CA",
      :adopter => 1
    )
    @contact2 = Contact.gen(
      :first_name => "The",
      :last_name => "Dude",
      :company_name => "Shelter Exchange, Inc",
      :mobile => "666-777-8888",
      :city => "San Bruno",
      :state => "CA",
      :volunteer => 1
    )
  end

  it "returns all contacts when no params" do
    contacts = Contact.search_and_filter(nil, nil, nil, nil)

    expect(contacts.count).to eq(2)
    expect(contacts).to match_array([@contact1, @contact2])
  end

  context "with phone search term" do

    it "searches for contacts exactly matching the phone" do
      contacts = Contact.search_and_filter("123-456-7890", nil, nil, nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact1])
    end

    it "searches for contacts exactly matching mobile" do
      contacts = Contact.search_and_filter("666-777-8888", nil, nil, nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact2])
    end
  end

  context "with alphanumeric search term" do

    it "searches where term is like the email" do
      contacts = Contact.search_and_filter("who@example.com", nil, nil, nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact1])
    end

    it "searches where term is like the first_name" do
      contacts = Contact.search_and_filter("Jimmy", nil, nil, nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact1])
    end

    it "searches where term is like the last_name" do
      contacts = Contact.search_and_filter("dude", nil, nil, nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact2])
    end

    it "searches where term is like the company_name" do
      contacts = Contact.search_and_filter("Shelter Exchange, Inc", nil, nil, nil)
      expect(contacts.count).to eq(2)
      expect(contacts).to match_array([@contact1, @contact2])
    end

    it "searches where term is like the city" do
      contacts = Contact.search_and_filter("Redwood", nil, nil, nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact1])
    end

    it "searches where term is like multiple query words" do
      contacts = Contact.search_and_filter("Dude Shelter Exchange", nil, nil, nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact2])
    end
  end

  context "with last name" do
    it "filters animals with last name" do
      contacts = Contact.search_and_filter(nil, "S", nil, nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact1])
    end
  end

  context "with role" do
    it "filters animals with role" do
      contacts = Contact.search_and_filter(nil, nil, "volunteer", nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact2])
    end
  end

  context "with order by" do
    it "Sorts the animals with the order by param" do
      contacts = Contact.search_and_filter(nil, nil, nil, "contacts.last_name ASC")
      expect(contacts.count).to eq(2)
      expect(contacts).to eq([@contact2, @contact1])
    end
  end

  context "with multiple search and filter criteria" do
    it "filters contacts with last name and role" do
      contacts = Contact.search_and_filter(nil, "S", "adopter", nil)
      expect(contacts.count).to eq(1)
      expect(contacts).to match_array([@contact1])
    end
  end
end

describe Contact, ".recent_activity" do

  it "returns only the most recent activity per limit" do
    contact1 = Contact.gen :updated_at => Time.now - 1.hour
    contact2 = Contact.gen :updated_at => Time.now
    Contact.gen :updated_at => Time.now - 2.hour

    results = Contact.recent_activity(2).all

    expect(results.count).to eq(2)
    expect(results).to match_array([contact1, contact2])
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

