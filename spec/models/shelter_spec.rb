require "rails_helper"

describe Shelter do

  it_should_behave_like Geocodeable
  it_should_behave_like StreetAddressable
  it_should_behave_like Uploadable

  it "validates presence of name" do
    shelter = Shelter.new :name => nil

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:name].size).to eq(1)
    expect(shelter.errors[:name]).to match_array(["cannot be blank"])
  end

  it "validates presence of phone" do
    shelter = Shelter.new :phone => nil

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:phone].size).to eq(1)
    expect(shelter.errors[:phone]).to match_array(["cannot be blank"])
  end

  it "validates format of phone" do
    shelter = Shelter.new :phone => "aaa"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:phone].size).to eq(1)
    expect(shelter.errors[:phone]).to match_array(["invalid phone number format"])

    shelter = Shelter.new :phone => "+011.999.00000"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:phone].size).to eq(1)
    expect(shelter.errors[:phone]).to match_array(["invalid phone number format"])
  end

  it "validates uniqueness of email" do
    Shelter.gen :email => "test@test.com"
    shelter = Shelter.new :email => "test@test.com"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:email].size).to eq(1)
    expect(shelter.errors[:email]).to match_array(["has already been taken"])
  end

  it "validates format of email" do
    shelter = Shelter.new :email => "blah.com"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:email].size).to eq(1)
    expect(shelter.errors[:email]).to match_array(["format is incorrect"])
  end

  it "validates inclusion of timezone" do
    shelter = Shelter.new :time_zone => "London"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:time_zone].size).to eq(1)
    expect(shelter.errors[:time_zone]).to match_array(["is not a valid US Time Zone"])

    shelter = Shelter.new :time_zone => "Eastern Time (US & Canada)"
    expect(shelter.errors[:time_zone].size).to eq(0)
  end

  it "validates url format for website" do
    shelter = Shelter.new :website => "save-the_doggies.com"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:website].size).to eq(1)
    expect(shelter.errors[:website]).to match_array(["format is incorrect"])
  end

  it "validates allows blank for website" do
    shelter = Shelter.new :website => nil

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:website].size).to eq(0)
  end

  it "validates url format for facebook" do
    shelter = Shelter.new :facebook => "facebook.com/test"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:facebook].size).to eq(1)
    expect(shelter.errors[:facebook]).to match_array(["format is incorrect"])
  end

  it "validates allows blank for facebook" do
    shelter = Shelter.new :facebook => nil

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:facebook].size).to eq(0)
  end

  it "validates twitter format for twitter" do
    shelter = Shelter.new :twitter => "savethedoggies"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:twitter].size).to eq(1)
    expect(shelter.errors[:twitter]).to match_array(["format is incorrect. Example @shelterexchange"])
  end

  it "validates allows blank for twitter" do
    shelter = Shelter.new :twitter => nil

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:twitter].size).to eq(0)
  end

  it "validates uniqueness of access token" do
    Shelter.gen :access_token => "access-token"
    shelter = Shelter.gen :access_token => "access-token"

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:access_token].size).to eq(1)
    expect(shelter.errors[:access_token]).to match_array(["has already been taken. Please generate another web token."])
  end

  it "validates allows blank for access_token" do
    shelter = Shelter.new :access_token => nil

    expect(shelter.valid?).to be_falsey
    expect(shelter.errors[:access_token].size).to eq(0)
  end

  context "Before Save" do

    describe "#clean_phone_numbers" do
      it "cleans the phone numbers to store without hyphens" do
        shelter = Shelter.gen(
          :phone => "123-456-7890",
          :fax => "098-765-4321"
        )
        expect(shelter.phone).to eq("1234567890")
        expect(shelter.fax).to eq("0987654321")
      end
    end

    describe "#clean_status_reason" do
      it "cleans the status reason when status changes" do
        shelter = Shelter.gen(
          :status => "cancelled",
          :status_reason => "Not nice :("
        )
        expect(shelter.status).to eq("cancelled")
        expect(shelter.status_reason).to eq("Not nice :(")

        shelter.status = "active"
        shelter.save!

        expect(shelter.status).to eq("active")
        expect(shelter.status_reason).to eq("")
      end
    end
  end

  context "After Save" do

    describe "#update_map_details" do
      it "enqueues map overlay job" do
        job = MapOverlayJob.new
        allow(MapOverlayJob).to receive(:new).and_return(job)
        expect(Delayed::Job).to receive(:enqueue).with(job)
        Shelter.gen
      end
    end
  end

  context "Nested Attributes" do

    it "accepts nested attributes for items" do
      expect(Shelter.count).to eq(0)
      expect(Item.count).to eq(0)

      Shelter.gen :items_attributes => [Item.attributes, Item.attributes]

      expect(Shelter.count).to eq(1)
      expect(Item.count).to eq(2)
    end
  end

  context "Mount Uploader" do

    it "returns a logo uploader for the logo" do
      shelter = Shelter.gen
      expect(shelter.logo).to be_kind_of(LogoUploader)
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Shelter, "::STATUSES" do
  it "contains a default list of statuses" do
    expect(Shelter::STATUSES).to match_array(["active", "suspended", "cancelled"])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Shelter, ".auto_complete" do

  it "returns shelters that are like the name parameter for any case" do
    shelter1 = Shelter.gen :name => "Saving Doggies"
    shelter2 = Shelter.gen :name => "Save the dogs"
    Shelter.gen :name => "Kitty Haven"

    shelters = Shelter.auto_complete("dog")
    expect(shelters.count).to eq(2)
    expect(shelters).to match_array([shelter1, shelter2])
  end
end

describe Shelter, ".kill_shelters" do

  it "returns shelters that are kill shelters" do
    shelter1 = Shelter.gen :is_kill_shelter => true
    shelter2 = Shelter.gen :is_kill_shelter => true
    Shelter.gen :is_kill_shelter => false

    shelters = Shelter.kill_shelters
    expect(shelters.count).to eq(2)
    expect(shelters).to match_array([shelter1, shelter2])
  end
end

describe Shelter, ".no_kill_shelters" do

  it "returns shelters that are not kill shelters" do
    shelter1 = Shelter.gen :is_kill_shelter => false
    shelter2 = Shelter.gen :is_kill_shelter => false
    Shelter.gen :is_kill_shelter => true

    shelters = Shelter.no_kill_shelters
    expect(shelters.count).to eq(2)
    expect(shelters).to match_array([shelter1, shelter2])
  end
end

describe Shelter, ".latest" do

  it "returns the latest shelters per the limit parameter" do
    shelter1 = Shelter.gen :created_at => Time.now - 10.days
    shelter2 = Shelter.gen :created_at => Time.now - 20.days
    shelter3 = Shelter.gen :created_at => Time.now
    shelter4 = Shelter.gen :created_at => Time.now - 5.days

    shelters = Shelter.latest(4)
    expect(shelters.count).to eq(4)
    expect(shelters).to match_array([shelter3, shelter4, shelter1, shelter2])
  end
end

describe Shelter, ".active" do

  it "returns the active shelters" do
    shelter1 = Shelter.gen :status => "active"
    shelter2 = Shelter.gen :status => "active"
    Shelter.gen :status => "suspended"

    shelters = Shelter.active
    expect(shelters.count).to eq(2)
    expect(shelters).to match_array([shelter1, shelter2])
  end
end

describe Shelter, ".inactive" do

  it "returns the inactive shelters" do
    shelter1 = Shelter.gen :status => "suspended"
    shelter2 = Shelter.gen :status => "suspended"
    Shelter.gen :status => "active"

    shelters = Shelter.inactive
    expect(shelters.count).to eq(2)
    expect(shelters).to match_array([shelter1, shelter2])
  end
end

describe Shelter, ".suspended" do

  it "returns the suspended shelters" do
    shelter1 = Shelter.gen :status => "suspended"
    shelter2 = Shelter.gen :status => "suspended"
    Shelter.gen :status => "active"

    shelters = Shelter.suspended
    expect(shelters.count).to eq(2)
    expect(shelters).to match_array([shelter1, shelter2])
  end
end

describe Shelter, ".cancelled" do

  it "returns the cancelled shelters" do
    shelter1 = Shelter.gen :status => "cancelled"
    shelter2 = Shelter.gen :status => "cancelled"
    Shelter.gen :status => "active"

    shelters = Shelter.cancelled
    expect(shelters.count).to eq(2)
    expect(shelters).to match_array([shelter1, shelter2])
  end
end

describe Shelter, ".by_access_token" do

  it "returns one shelter by access_token" do
    shelter1 = Shelter.gen :access_token => "access-token"
    Shelter.gen :access_token => "access-token-1"

    shelter = Shelter.by_access_token("access-token").first
    expect(shelter).to eq(shelter1)
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Shelter, "#account" do

  it "belongs to a account" do
    account = Account.new
    shelter = Shelter.new :account => account

    expect(shelter.account).to eq(account)
  end
end

describe Shelter, "#users" do

  before do
    account = Account.gen :users => [
      @user1 = User.gen,
      @user2 = User.gen
    ]
    @shelter = Shelter.gen :account => account
  end

  it "returns a list of users" do
    expect(@shelter.users.count).to eq(2)
    expect(@shelter.users).to match_array([@user1, @user2])
  end
end

describe Shelter, "#locations" do

  before do
    @shelter = Shelter.gen
    @location1 = Location.gen :shelter => @shelter
    @location2 = Location.gen :shelter => @shelter
  end

  it "returns a list of locations" do
    expect(@shelter.locations.count).to eq(2)
    expect(@shelter.locations).to match_array([@location1, @location2])
  end

  it "destroy all locations associated to the shelter" do
    expect(@shelter.locations.count).to eq(2)
    @shelter.destroy
    expect(@shelter.locations.count).to eq(0)
  end
end

describe Shelter, "#accommodations" do

  before do
    @shelter = Shelter.gen
    @accommodation1 = Accommodation.gen :shelter => @shelter
    @accommodation2 = Accommodation.gen :shelter => @shelter
  end

  it "returns a list of accommodations" do
    expect(@shelter.accommodations.count).to eq(2)
    expect(@shelter.accommodations).to match_array([@accommodation1, @accommodation2])
  end

  it "destroy all accommodations associated to the shelter" do
    expect(@shelter.accommodations.count).to eq(2)
    @shelter.destroy
    expect(@shelter.accommodations.count).to eq(0)
  end
end

describe Shelter, "#contacts" do

  before do
    @shelter = Shelter.gen
    @contact1 = Contact.gen :shelter => @shelter
    @contact2 = Contact.gen :shelter => @shelter
  end

  it "returns a list of contacts" do
    expect(@shelter.contacts.count).to eq(2)
    expect(@shelter.contacts).to match_array([@contact1, @contact2])
  end

  it "destroy all contacts associated to the shelter" do
    expect(@shelter.contacts.count).to eq(2)
    @shelter.destroy
    expect(@shelter.contacts.count).to eq(0)
  end
end

describe Shelter, "#animals" do

  before do
    @shelter = Shelter.gen
    @animal1 = Animal.gen :shelter => @shelter
    @animal2 = Animal.gen :shelter => @shelter
  end

  it "returns a list of animals" do
    expect(@shelter.animals.count).to eq(2)
    expect(@shelter.animals).to match_array([@animal1, @animal2])
  end

  it "destroy all animals associated to the shelter" do
    expect(@shelter.animals.count).to eq(2)
    @shelter.destroy
    expect(@shelter.animals.count).to eq(0)
  end
end

describe Shelter, "#notes" do

  before do
    @shelter = Shelter.gen
    @note1 = Note.gen :shelter => @shelter
    @note2 = Note.gen :shelter => @shelter
  end

  it "returns a list of notes" do
    expect(@shelter.notes.count).to eq(2)
    expect(@shelter.notes).to match_array([@note1, @note2])
  end

  it "destroy all notes associated to the shelter" do
    expect(@shelter.notes.count).to eq(2)
    @shelter.destroy
    expect(@shelter.notes.count).to eq(0)
  end
end

describe Shelter, "#tasks" do

  before do
    @shelter = Shelter.gen
    @task1 = Task.gen :shelter => @shelter
    @task2 = Task.gen :shelter => @shelter
  end

  it "returns a list of tasks" do
    expect(@shelter.tasks.count).to eq(2)
    expect(@shelter.tasks).to match_array([@task1, @task2])
  end

  it "destroy all tasks associated to the shelter" do
    expect(@shelter.tasks.count).to eq(2)
    @shelter.destroy
    expect(@shelter.tasks.count).to eq(0)
  end
end

describe Shelter, "#alerts" do

  before do
    @shelter = Shelter.gen
    @alert1 = Alert.gen :shelter => @shelter
    @alert2 = Alert.gen :shelter => @shelter
  end

  it "returns a list of alerts" do
    expect(@shelter.alerts.count).to eq(2)
    expect(@shelter.alerts).to match_array([@alert1, @alert2])
  end

  it "destroy all alerts associated to the shelter" do
    expect(@shelter.alerts.count).to eq(2)
    @shelter.destroy
    expect(@shelter.alerts.count).to eq(0)
  end
end

describe Shelter, "#comments" do

  before do
    @shelter = Shelter.gen
    @comment1 = Comment.gen :shelter => @shelter
    @comment2 = Comment.gen :shelter => @shelter
  end

  it "returns a list of comments" do
    expect(@shelter.comments.count).to eq(2)
    expect(@shelter.comments).to match_array([@comment1, @comment2])
  end

  it "destroy all comments associated to the shelter" do
    expect(@shelter.comments.count).to eq(2)
    @shelter.destroy
    expect(@shelter.comments.count).to eq(0)
  end
end

describe Shelter, "#items" do

  before do
    @shelter = Shelter.gen
    @item1 = Item.gen :shelter => @shelter
    @item2 = Item.gen :shelter => @shelter
  end

  it "returns a list of items" do
    expect(@shelter.items.count).to eq(2)
    expect(@shelter.items).to match_array([@item1, @item2])
  end

  it "destroy all items associated to the shelter" do
    expect(@shelter.items.count).to eq(2)
    @shelter.destroy
    expect(@shelter.items.count).to eq(0)
  end
end

describe Shelter, "#capacities" do

  before do
    @shelter = Shelter.gen
    @capacity1 = Capacity.gen :shelter => @shelter
    @capacity2 = Capacity.gen :shelter => @shelter
  end

  it "returns a list of capacities" do
    expect(@shelter.capacities.count).to eq(2)
    expect(@shelter.capacities).to match_array([@capacity1, @capacity2])
  end

  it "destroy all capacities associated to the shelter" do
    expect(@shelter.capacities.count).to eq(2)
    @shelter.destroy
    expect(@shelter.capacities.count).to eq(0)
  end
end

describe Shelter, "#status_histories" do

  before do
    @shelter = Shelter.gen
    @status_history1 = StatusHistory.gen :shelter => @shelter
    @status_history2 = StatusHistory.gen :shelter => @shelter
  end

  it "returns a list of status histories" do
    expect(@shelter.status_histories.count).to eq(2)
    expect(@shelter.status_histories).to match_array([@status_history1, @status_history2])
  end

  it "destroy all status histories associated to the shelter" do
    expect(@shelter.status_histories.count).to eq(2)
    @shelter.destroy
    expect(@shelter.status_histories.count).to eq(0)
  end
end

describe Shelter, "#transfers" do

  before do
    @shelter = Shelter.gen
    @transfer1 = Transfer.gen :shelter => @shelter
    @transfer2 = Transfer.gen :shelter => @shelter
  end

  it "returns a list of transfers" do
    expect(@shelter.transfers.count).to eq(2)
    expect(@shelter.transfers).to match_array([@transfer1, @transfer2])
  end

  it "destroy all transfers associated to the shelter" do
    expect(@shelter.transfers.count).to eq(2)
    @shelter.destroy
    expect(@shelter.transfers.count).to eq(0)
  end
end

describe Shelter, "#integrations" do

  before do
    @shelter = Shelter.gen
    @integration1 = Integration.gen :shelter => @shelter
    @integration2 = Integration.gen :shelter => @shelter
  end

  it "returns a list of integrations" do
    expect(@shelter.integrations.count).to eq(2)
    expect(@shelter.integrations).to match_array([@integration1, @integration2])
  end

  it "destroy all integrations associated to the shelter" do
    expect(@shelter.integrations.count).to eq(2)
    @shelter.destroy
    expect(@shelter.integrations.count).to eq(0)
  end
end

describe Shelter, "#settings" do

  before do
    @shelter = Shelter.gen
    @setting1 = Setting.gen :shelter => @shelter
    @setting2 = Setting.gen :shelter => @shelter
  end

  it "returns a list of settings" do
    expect(@shelter.settings.count).to eq(2)
    expect(@shelter.settings).to match_array([@setting1, @setting2])
  end

  it "destroy all settings associated to the shelter" do
    expect{
      @shelter.destroy
    }.to change(Setting, :count).by(-2)
  end
end

describe Shelter, "#kill_shelter?" do

  it "returns true if the shelter is a kill shelter" do
    shelter1 = Shelter.new :is_kill_shelter => true
    shelter2 = Shelter.new :is_kill_shelter => false

    expect(shelter1.kill_shelter?).to eq(true)
    expect(shelter2.kill_shelter?).to eq(false)
  end
end

describe Shelter, "#no_kill_shelter?" do

  it "returns true if the shelter is not kill shelter" do
    shelter1 = Shelter.new :is_kill_shelter => false
    shelter2 = Shelter.new :is_kill_shelter => true

    expect(shelter1.no_kill_shelter?).to eq(true)
    expect(shelter2.no_kill_shelter?).to eq(false)
  end
end

describe Shelter, "#active?" do

  it "returns true if the shelter is active" do
    shelter1 = Shelter.new :status => "active"
    shelter2 = Shelter.new :status => "cancelled"

    expect(shelter1.active?).to eq(true)
    expect(shelter2.active?).to eq(false)
  end
end

describe Shelter, "#inactive?" do

  it "returns true if the shelter is inactive" do
    shelter1 = Shelter.new :status => "cancelled"
    shelter2 = Shelter.new :status => "suspended"
    shelter3 = Shelter.new :status => "active"

    expect(shelter1.inactive?).to eq(true)
    expect(shelter2.inactive?).to eq(true)
    expect(shelter3.inactive?).to eq(false)
  end
end

describe Shelter, "#suspended?" do

  it "returns true if the shelter is suspended" do
    shelter1 = Shelter.new :status => "suspended"
    shelter2 = Shelter.new :status => "active"

    expect(shelter1.suspended?).to eq(true)
    expect(shelter2.suspended?).to eq(false)
  end
end

describe Shelter, "#cancelled?" do

  it "returns true if the shelter is cancelled" do
    shelter1 = Shelter.new :status => "cancelled"
    shelter2 = Shelter.new :status => "active"

    expect(shelter1.cancelled?).to eq(true)
    expect(shelter2.cancelled?).to eq(false)
  end
end

describe Shelter, "#generate_access_token!" do

  it "generates a new access token for the shelter" do
    allow(SecureRandom).to receive(:hex).and_return("access_token")

    shelter = Shelter.gen
    shelter.generate_access_token!
    expect(shelter.access_token).to eq("access_token")
  end
end


# Class Methods
#----------------------------------------------------------------------------
describe Shelter, ".live_search" do

  context "with no search term" do

    before do
      @shelter1 = Shelter.gen :state => "CA"
      @shelter2 = Shelter.gen :state => "CA"
      @shelter3 = Shelter.gen :state => "PA"
    end

    it "returns all shelters when no params" do
      shelters = Shelter.live_search("", {})
      expect(shelters.count).to eq(3)
      expect(shelters).to match_array([@shelter1, @shelter2, @shelter3])
    end

    it "returns all shelters with state only" do
      shelters = Shelter.live_search("", { :shelters => { :state => "CA" } })
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([@shelter1, @shelter2])
    end
  end

  context "with search term" do

    it "returns all shelters with the name like" do
      shelter1 = Shelter.gen :name => "DoggieTown"
      shelter2 = Shelter.gen :name => "DogTown"
      Shelter.gen :name => "KittyTown"
      Shelter.gen :name => "CatTown"

      shelters = Shelter.live_search("dog",{})
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([shelter1, shelter2])
    end

    it "returns all shelters with the email like" do
      shelter1 = Shelter.gen :email => "kitty1@test.com"
      shelter2 = Shelter.gen :email => "kitty2@test.com"
      Shelter.gen :email => "doggie1@test.com"
      Shelter.gen :email => "doggie2@test.com"

      shelters = Shelter.live_search("kitty",{})
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([shelter1, shelter2])
    end

    it "returns all shelters with the city like" do
      shelter1 = Shelter.gen :city => "animaltown"
      shelter2 = Shelter.gen :city => "sleepytown"
      Shelter.gen :city => "Redwood City"

      shelters = Shelter.live_search("town",{})
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([shelter1, shelter2])
    end

    it "returns all shelters with the zip_code like" do

      shelter1 = Shelter.gen :zip_code => "94063"
      shelter2 = Shelter.gen :zip_code => "94061"
      Shelter.gen :zip_code => "96063"

      shelters = Shelter.live_search("9406",{})
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([shelter1, shelter2])
    end

    it "returns all shelters with the facebook like" do
      shelter1 = Shelter.gen :facebook => "http://facebook.com/daycare1"
      shelter2 = Shelter.gen :facebook => "http://facebook.com/daycare2"
      Shelter.gen :facebook => "http://facebook.com/rescue"

      shelters = Shelter.live_search("daycare",{})
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([shelter1, shelter2])
    end
    it "returns all shelters with the twitter like" do
      shelter1 = Shelter.gen :twitter => "@daycare1"
      shelter2 = Shelter.gen :twitter => "@daycare2"
      Shelter.gen :twitter => "@shelterexchange"

      shelters = Shelter.live_search("daycare",{})
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([shelter1, shelter2])
    end
  end
end

describe Shelter, ".search_by_name" do

  context "with no search term" do

    before do
      @shelter1 = Shelter.gen :state => "CA"
      @shelter2 = Shelter.gen :state => "CA"
      @shelter3 = Shelter.gen :state => "PA"
    end

    it "returns all shelters when no params" do
      shelters = Shelter.search_by_name("", {})
      expect(shelters.count).to eq(3)
      expect(shelters).to match_array([@shelter1, @shelter2, @shelter3])
    end

    it "returns all shelters with state only" do
      shelters = Shelter.search_by_name("", { :shelters => { :state => "CA" } })
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([@shelter1, @shelter2])
    end
  end

  context "with search term" do

    it "returns all shelters with the name like" do
      shelter1 = Shelter.gen :name => "DoggieTown"
      shelter2 = Shelter.gen :name => "DogTown"
      Shelter.gen :name => "KittyTown"
      Shelter.gen :name => "CatTown"

      shelters = Shelter.search_by_name("dog",{})
      expect(shelters.count).to eq(2)
      expect(shelters).to match_array([shelter1, shelter2])
    end
  end
end

