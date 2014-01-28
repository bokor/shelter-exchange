require "spec_helper"

describe Shelter do

  it_should_behave_like Geocodeable
  it_should_behave_like StreetAddressable
  it_should_behave_like Uploadable

  it "validates presence of name" do
    shelter = Shelter.new :name => nil
    shelter.should have(1).error_on(:name)
    shelter.errors[:name].should match_array(["cannot be blank"])
  end

  it "validates presence of phone" do
    shelter = Shelter.new :phone => nil
    shelter.should have(1).error_on(:phone)
    shelter.errors[:phone].should match_array(["cannot be blank"])
  end

  it "validates format of phone" do
    shelter = Shelter.new :phone => "aaa"
    shelter.should have(1).error_on(:phone)
    shelter.errors[:phone].should match_array(["invalid phone number format"])

    shelter = Shelter.new :phone => "+011.999.00000"
    shelter.should have(1).error_on(:phone)
    shelter.errors[:phone].should match_array(["invalid phone number format"])
  end

  it "validates uniqueness of email" do
    Shelter.gen :email => "test@test.com"
    shelter = Shelter.new :email => "test@test.com"
    shelter.should have(1).error_on(:email)
    shelter.errors[:email].should match_array(["has already been taken"])
  end

  it "validates format of email" do
    shelter = Shelter.new :email => "blah.com"
    shelter.should have(1).error_on(:email)
    shelter.errors[:email].should match_array(["format is incorrect"])
  end

  it "validates inclusion of timezone" do
    shelter = Shelter.new :time_zone => "London"
    shelter.should have(1).error_on(:time_zone)
    shelter.errors[:time_zone].should match_array(["is not a valid US Time Zone"])

    shelter = Shelter.new :time_zone => "Eastern Time (US & Canada)"
    shelter.should have(0).error_on(:time_zone)
  end

  it "validates url format for website" do
    shelter = Shelter.new :website => "save-the_doggies.com"
    shelter.should have(1).error_on(:website)
    shelter.errors[:website].should match_array(["format is incorrect"])
  end

  it "validates allows blank for website" do
    shelter = Shelter.new :website => nil
    shelter.should have(0).error_on(:website)
  end

  it "validates url format for facebook" do
    shelter = Shelter.new :facebook => "facebook.com/test"
    shelter.should have(1).error_on(:facebook)
    shelter.errors[:facebook].should match_array(["format is incorrect"])
  end

  it "validates allows blank for facebook" do
    shelter = Shelter.new :facebook => nil
    shelter.should have(0).error_on(:facebook)
  end

  it "validates twitter format for twitter" do
    shelter = Shelter.new :twitter => "savethedoggies"
    shelter.should have(1).error_on(:twitter)
    shelter.errors[:twitter].should match_array(["format is incorrect. Example @shelterexchange"])
  end

  it "validates allows blank for twitter" do
    shelter = Shelter.new :twitter => nil
    shelter.should have(0).error_on(:twitter)
  end

  it "validates uniqueness of access token" do
    Shelter.gen :access_token => "access-token"
    shelter = Shelter.gen :access_token => "access-token"
    shelter.should have(1).error_on(:access_token)
    shelter.errors[:access_token].should match_array(["has already been taken. Please generate another web token."])
  end

  it "validates allows blank for access_token" do
    shelter = Shelter.new :access_token => nil
    shelter.should have(0).error_on(:access_token)
  end

  context "Before Save" do

    it "cleans the phone numbers to store without hyphens" do
      shelter = Shelter.gen(
        :phone => "123-456-7890",
        :fax => "098-765-4321"
      )
      shelter.phone.should == "1234567890"
      shelter.fax.should == "0987654321"
    end

    it "cleans the status reason when status changes" do
      shelter = Shelter.gen(
        :status => "cancelled",
        :status_reason => "Not nice :("
      )
      shelter.status.should == "cancelled"
      shelter.status_reason.should == "Not nice :("

      shelter.status = "active"
      shelter.save!

      shelter.status.should == "active"
      shelter.status_reason.should == ""
    end
  end

  context "Nested Attributes" do

    it "accepts nested attributes for items" do
      Shelter.count.should == 0
      Item.count.should == 0

      Shelter.gen :items_attributes => [Item.attributes, Item.attributes]

      Shelter.count.should == 1
      Item.count.should == 2
    end
  end

  context "Mount Uploader" do

    it "returns a logo uploader for the logo" do
      shelter = Shelter.gen
      shelter.logo.should be_kind_of(LogoUploader)
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Shelter, "::STATUSES" do
  it "contains a default list of statuses" do
    Shelter::STATUSES.should match_array(["active", "suspended", "cancelled"])
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
    shelters.count.should == 2
    shelters.should match_array([shelter1, shelter2])
  end
end

describe Shelter, ".kill_shelters" do

  it "returns shelters that are kill shelters" do
    shelter1 = Shelter.gen :is_kill_shelter => true
    shelter2 = Shelter.gen :is_kill_shelter => true
    Shelter.gen :is_kill_shelter => false

    shelters = Shelter.kill_shelters
    shelters.count.should == 2
    shelters.should match_array([shelter1, shelter2])
  end
end

describe Shelter, ".no_kill_shelters" do

  it "returns shelters that are not kill shelters" do
    shelter1 = Shelter.gen :is_kill_shelter => false
    shelter2 = Shelter.gen :is_kill_shelter => false
    Shelter.gen :is_kill_shelter => true

    shelters = Shelter.no_kill_shelters
    shelters.count.should == 2
    shelters.should match_array([shelter1, shelter2])
  end
end

describe Shelter, ".latest" do

  it "returns the latest shelters per the limit parameter" do
    shelter1 = Shelter.gen :created_at => Time.now - 10.days
    shelter2 = Shelter.gen :created_at => Time.now - 20.days
    shelter3 = Shelter.gen :created_at => Time.now
    shelter4 = Shelter.gen :created_at => Time.now - 5.days

    shelters = Shelter.latest(4)
    shelters.count.should == 4
    shelters.should match_array([shelter3, shelter4, shelter1, shelter2])
  end
end

describe Shelter, ".active" do

  it "returns the active shelters" do
    shelter1 = Shelter.gen :status => "active"
    shelter2 = Shelter.gen :status => "active"
    Shelter.gen :status => "suspended"

    shelters = Shelter.active
    shelters.count.should == 2
    shelters.should match_array([shelter1, shelter2])
  end
end

describe Shelter, ".inactive" do

  it "returns the inactive shelters" do
    shelter1 = Shelter.gen :status => "suspended"
    shelter2 = Shelter.gen :status => "suspended"
    Shelter.gen :status => "active"

    shelters = Shelter.inactive
    shelters.count.should == 2
    shelters.should match_array([shelter1, shelter2])
  end
end

describe Shelter, ".suspended" do

  it "returns the suspended shelters" do
    shelter1 = Shelter.gen :status => "suspended"
    shelter2 = Shelter.gen :status => "suspended"
    Shelter.gen :status => "active"

    shelters = Shelter.suspended
    shelters.count.should == 2
    shelters.should match_array([shelter1, shelter2])
  end
end

describe Shelter, ".cancelled" do

  it "returns the cancelled shelters" do
    shelter1 = Shelter.gen :status => "cancelled"
    shelter2 = Shelter.gen :status => "cancelled"
    Shelter.gen :status => "active"

    shelters = Shelter.cancelled
    shelters.count.should == 2
    shelters.should match_array([shelter1, shelter2])
  end
end

describe Shelter, ".by_access_token" do

  it "returns one shelter by access_token" do
    shelter1 = Shelter.gen :access_token => "access-token"
    Shelter.gen :access_token => "access-token-1"

    shelter = Shelter.by_access_token("access-token").first
    shelter.should == shelter1
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Shelter, "#account" do

  it "belongs to a account" do
    account = Account.new
    shelter = Shelter.new :account => account

    shelter.account.should == account
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
    @shelter.users.count.should == 2
    @shelter.users.should match_array([@user1, @user2])
  end
end

describe Shelter, "#locations" do

  before do
    @shelter = Shelter.gen
    @location1 = Location.gen :shelter => @shelter
    @location2 = Location.gen :shelter => @shelter
  end

  it "returns a list of locations" do
    @shelter.locations.count.should == 2
    @shelter.locations.should match_array([@location1, @location2])
  end

  it "destroy all locations associated to the shelter" do
    @shelter.locations.count.should == 2
    @shelter.destroy
    @shelter.locations.count.should == 0
  end
end

describe Shelter, "#accommodations" do

  before do
    @shelter = Shelter.gen
    @accommodation1 = Accommodation.gen :shelter => @shelter
    @accommodation2 = Accommodation.gen :shelter => @shelter
  end

  it "returns a list of accommodations" do
    @shelter.accommodations.count.should == 2
    @shelter.accommodations.should match_array([@accommodation1, @accommodation2])
  end

  it "destroy all accommodations associated to the shelter" do
    @shelter.accommodations.count.should == 2
    @shelter.destroy
    @shelter.accommodations.count.should == 0
  end
end

describe Shelter, "#placements" do

  before do
    @shelter = Shelter.gen
    @placement1 = Placement.gen :shelter => @shelter
    @placement2 = Placement.gen :shelter => @shelter
  end

  it "returns a list of placements" do
    @shelter.placements.count.should == 2
    @shelter.placements.should match_array([@placement1, @placement2])
  end

  it "destroy all placements associated to the shelter" do
    @shelter.placements.count.should == 2
    @shelter.destroy
    @shelter.placements.count.should == 0
  end
end

describe Shelter, "#animals" do

  before do
    @shelter = Shelter.gen
    @animal1 = Animal.gen :shelter => @shelter
    @animal2 = Animal.gen :shelter => @shelter
  end

  it "returns a list of animals" do
    @shelter.animals.count.should == 2
    @shelter.animals.should match_array([@animal1, @animal2])
  end

  it "destroy all animals associated to the shelter" do
    @shelter.animals.count.should == 2
    @shelter.destroy
    @shelter.animals.count.should == 0
  end
end

describe Shelter, "#notes" do

  before do
    @shelter = Shelter.gen
    @note1 = Note.gen :shelter => @shelter
    @note2 = Note.gen :shelter => @shelter
  end

  it "returns a list of notes" do
    @shelter.notes.count.should == 2
    @shelter.notes.should match_array([@note1, @note2])
  end

  it "destroy all notes associated to the shelter" do
    @shelter.notes.count.should == 2
    @shelter.destroy
    @shelter.notes.count.should == 0
  end
end

describe Shelter, "#tasks" do

  before do
    @shelter = Shelter.gen
    @task1 = Task.gen :shelter => @shelter
    @task2 = Task.gen :shelter => @shelter
  end

  it "returns a list of tasks" do
    @shelter.tasks.count.should == 2
    @shelter.tasks.should match_array([@task1, @task2])
  end

  it "destroy all tasks associated to the shelter" do
    @shelter.tasks.count.should == 2
    @shelter.destroy
    @shelter.tasks.count.should == 0
  end
end

describe Shelter, "#alerts" do

  before do
    @shelter = Shelter.gen
    @alert1 = Alert.gen :shelter => @shelter
    @alert2 = Alert.gen :shelter => @shelter
  end

  it "returns a list of alerts" do
    @shelter.alerts.count.should == 2
    @shelter.alerts.should match_array([@alert1, @alert2])
  end

  it "destroy all alerts associated to the shelter" do
    @shelter.alerts.count.should == 2
    @shelter.destroy
    @shelter.alerts.count.should == 0
  end
end

describe Shelter, "#comments" do

  before do
    @shelter = Shelter.gen
    @comment1 = Comment.gen :shelter => @shelter
    @comment2 = Comment.gen :shelter => @shelter
  end

  it "returns a list of comments" do
    @shelter.comments.count.should == 2
    @shelter.comments.should match_array([@comment1, @comment2])
  end

  it "destroy all comments associated to the shelter" do
    @shelter.comments.count.should == 2
    @shelter.destroy
    @shelter.comments.count.should == 0
  end
end

describe Shelter, "#items" do

  before do
    @shelter = Shelter.gen
    @item1 = Item.gen :shelter => @shelter
    @item2 = Item.gen :shelter => @shelter
  end

  it "returns a list of items" do
    @shelter.items.count.should == 2
    @shelter.items.should match_array([@item1, @item2])
  end

  it "destroy all items associated to the shelter" do
    @shelter.items.count.should == 2
    @shelter.destroy
    @shelter.items.count.should == 0
  end
end

describe Shelter, "#capacities" do

  before do
    @shelter = Shelter.gen
    @capacity1 = Capacity.gen :shelter => @shelter
    @capacity2 = Capacity.gen :shelter => @shelter
  end

  it "returns a list of capacities" do
    @shelter.capacities.count.should == 2
    @shelter.capacities.should match_array([@capacity1, @capacity2])
  end

  it "destroy all capacities associated to the shelter" do
    @shelter.capacities.count.should == 2
    @shelter.destroy
    @shelter.capacities.count.should == 0
  end
end

describe Shelter, "#status_histories" do

  before do
    @shelter = Shelter.gen
    @status_history1 = StatusHistory.gen :shelter => @shelter
    @status_history2 = StatusHistory.gen :shelter => @shelter
  end

  it "returns a list of status histories" do
    @shelter.status_histories.count.should == 2
    @shelter.status_histories.should match_array([@status_history1, @status_history2])
  end

  it "destroy all status histories associated to the shelter" do
    @shelter.status_histories.count.should == 2
    @shelter.destroy
    @shelter.status_histories.count.should == 0
  end
end

describe Shelter, "#transfers" do

  before do
    @shelter = Shelter.gen
    @transfer1 = Transfer.gen :shelter => @shelter
    @transfer2 = Transfer.gen :shelter => @shelter
  end

  it "returns a list of transfers" do
    @shelter.transfers.count.should == 2
    @shelter.transfers.should match_array([@transfer1, @transfer2])
  end

  it "destroy all transfers associated to the shelter" do
    @shelter.transfers.count.should == 2
    @shelter.destroy
    @shelter.transfers.count.should == 0
  end
end

describe Shelter, "#integrations" do

  before do
    @shelter = Shelter.gen
    @integration1 = Integration.gen :shelter => @shelter
    @integration2 = Integration.gen :shelter => @shelter
  end

  it "returns a list of integrations" do
    @shelter.integrations.count.should == 2
    @shelter.integrations.should match_array([@integration1, @integration2])
  end

  it "destroy all integrations associated to the shelter" do
    @shelter.integrations.count.should == 2
    @shelter.destroy
    @shelter.integrations.count.should == 0
  end
end

describe Shelter, "#kill_shelter?" do

  it "returns true if the shelter is a kill shelter" do
    shelter1 = Shelter.new :is_kill_shelter => true
    shelter2 = Shelter.new :is_kill_shelter => false

    shelter1.kill_shelter?.should == true
    shelter2.kill_shelter?.should == false
  end
end

describe Shelter, "#no_kill_shelter?" do

  it "returns true if the shelter is not kill shelter" do
    shelter1 = Shelter.new :is_kill_shelter => false
    shelter2 = Shelter.new :is_kill_shelter => true

    shelter1.no_kill_shelter?.should == true
    shelter2.no_kill_shelter?.should == false
  end
end

describe Shelter, "#active?" do

  it "returns true if the shelter is active" do
    shelter1 = Shelter.new :status => "active"
    shelter2 = Shelter.new :status => "cancelled"

    shelter1.active?.should == true
    shelter2.active?.should == false
  end
end

describe Shelter, "#inactive?" do

  it "returns true if the shelter is inactive" do
    shelter1 = Shelter.new :status => "cancelled"
    shelter2 = Shelter.new :status => "suspended"
    shelter3 = Shelter.new :status => "active"

    shelter1.inactive?.should == true
    shelter2.inactive?.should == true
    shelter3.inactive?.should == false
  end
end

describe Shelter, "#suspended?" do

  it "returns true if the shelter is suspended" do
    shelter1 = Shelter.new :status => "suspended"
    shelter2 = Shelter.new :status => "active"

    shelter1.suspended?.should == true
    shelter2.suspended?.should == false
  end
end

describe Shelter, "#cancelled?" do

  it "returns true if the shelter is cancelled" do
    shelter1 = Shelter.new :status => "cancelled"
    shelter2 = Shelter.new :status => "active"

    shelter1.cancelled?.should == true
    shelter2.cancelled?.should == false
  end
end

describe Shelter, "#generate_access_token!" do

  it "generates a new access token for the shelter" do
    SecureRandom.stub(:hex).and_return("access_token")

    shelter = Shelter.gen
    shelter.generate_access_token!
    shelter.access_token.should == "access_token"
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
      shelters.count.should == 3
      shelters.should match_array([@shelter1, @shelter2, @shelter3])
    end

    it "returns all shelters with state only" do
      shelters = Shelter.live_search("", { :shelters => { :state => "CA" } })
      shelters.count.should == 2
      shelters.should match_array([@shelter1, @shelter2])
    end
  end

  context "with search term" do

    it "returns all shelters with the name like" do
      shelter1 = Shelter.gen :name => "DoggieTown"
      shelter2 = Shelter.gen :name => "DogTown"
      Shelter.gen :name => "KittyTown"
      Shelter.gen :name => "CatTown"

      shelters = Shelter.live_search("dog",{})
      shelters.count.should == 2
      shelters.should match_array([shelter1, shelter2])
    end

    it "returns all shelters with the email like" do
      shelter1 = Shelter.gen :email => "kitty1@test.com"
      shelter2 = Shelter.gen :email => "kitty2@test.com"
      Shelter.gen :email => "doggie1@test.com"
      Shelter.gen :email => "doggie2@test.com"

      shelters = Shelter.live_search("kitty",{})
      shelters.count.should == 2
      shelters.should match_array([shelter1, shelter2])
    end

    it "returns all shelters with the city like" do
      shelter1 = Shelter.gen :city => "animaltown"
      shelter2 = Shelter.gen :city => "sleepytown"
      Shelter.gen :city => "Redwood City"

      shelters = Shelter.live_search("town",{})
      shelters.count.should == 2
      shelters.should match_array([shelter1, shelter2])
    end

    it "returns all shelters with the zip_code like" do

      shelter1 = Shelter.gen :zip_code => "94063"
      shelter2 = Shelter.gen :zip_code => "94061"
      Shelter.gen :zip_code => "96063"

      shelters = Shelter.live_search("9406",{})
      shelters.count.should == 2
      shelters.should match_array([shelter1, shelter2])
    end

    it "returns all shelters with the facebook like" do
      shelter1 = Shelter.gen :facebook => "http://facebook.com/daycare1"
      shelter2 = Shelter.gen :facebook => "http://facebook.com/daycare2"
      Shelter.gen :facebook => "http://facebook.com/rescue"

      shelters = Shelter.live_search("daycare",{})
      shelters.count.should == 2
      shelters.should match_array([shelter1, shelter2])
    end
    it "returns all shelters with the twitter like" do
      shelter1 = Shelter.gen :twitter => "@daycare1"
      shelter2 = Shelter.gen :twitter => "@daycare2"
      Shelter.gen :twitter => "@shelterexchange"

      shelters = Shelter.live_search("daycare",{})
      shelters.count.should == 2
      shelters.should match_array([shelter1, shelter2])
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
      shelters.count.should == 3
      shelters.should match_array([@shelter1, @shelter2, @shelter3])
    end

    it "returns all shelters with state only" do
      shelters = Shelter.search_by_name("", { :shelters => { :state => "CA" } })
      shelters.count.should == 2
      shelters.should match_array([@shelter1, @shelter2])
    end
  end

  context "with search term" do

    it "returns all shelters with the name like" do
      shelter1 = Shelter.gen :name => "DoggieTown"
      shelter2 = Shelter.gen :name => "DogTown"
      Shelter.gen :name => "KittyTown"
      Shelter.gen :name => "CatTown"

      shelters = Shelter.search_by_name("dog",{})
      shelters.count.should == 2
      shelters.should match_array([shelter1, shelter2])
    end
  end
end

