require "spec_helper"

describe User do

  it "requires presence of name" do
    user = User.new :name => nil
    user.should have(1).error_on(:name)
    user.errors[:name].should == ["cannot be blank"]
  end

  context "Before Create" do
    it "sets the default announcement hide time as now" do
      now = Time.now
      Time.stub!(:now).and_return(now)

      user = User.gen
      user.announcement_hide_time.should == now
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe User, "::ROLES" do
  it "contains a default list of roles" do
    User::ROLES.should == ["user", "admin"]
  end
end

describe User, "::OWNER" do
  it "contains the owner value" do
    User::OWNER.should == "owner"
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe User, ".owner" do

  it "returns all of the users that are role owner" do
    user1 = User.gen :role => "owner"
    user2 = User.gen :role => "admin"
    user3 = User.gen :role => "user"

    users = User.owner.all

    users.count.should == 1
    users.should       == [user1]
  end
end

describe User, ".admin" do

  it "returns all of the users that are role admin" do
    user1 = User.gen :role => "owner"
    user2 = User.gen :role => "admin"
    user3 = User.gen :role => "user"

    users = User.admin.all

    users.count.should == 1
    users.should       == [user2]
  end
end

describe User, ".default" do

  it "returns all of the users that are role user" do
    user1 = User.gen :role => "owner"
    user2 = User.gen :role => "admin"
    user3 = User.gen :role => "user"

    users = User.default.all

    users.count.should == 1
    users.should       == [user3]
  end
end

describe User, ".admin_list" do

  it "returns an ordered list of user names, emails, shelter ids, and shelter names" do
    shelter1 = Shelter.gen(:name => "oranges")
    user1 = User.gen(:name => "helper", :email => "helper@se.test")

    shelter2 = Shelter.gen(:name => "apples")
    user2 = User.gen(:name => "saver", :email => "saver@se.test")

    account1 = Account.gen(
      :users => [user1],
      :shelters => [shelter1]
    )

    account2 = Account.gen(
      :users => [user2],
      :shelters => [shelter2]
    )

    admin_list = User.admin_list

    admin_list.count.should == 2

    list_user1 = admin_list[0]
    list_user1.email.should == "saver@se.test"
    list_user1.name.should == "saver"
    list_user1.shelter_id.should == shelter2.id
    list_user1.shelter_name.should == "apples"

    list_user2 = admin_list[1]
    list_user2.email.should == "helper@se.test"
    list_user2.name.should == "helper"
    list_user2.shelter_id.should == shelter1.id
    list_user2.shelter_name.should == "oranges"
  end
end

describe User, ".find_for_authentication" do

  it "returns a user that matches the authentication criteria" do
    account = Account.gen
    user    = account.users.first

    authenicated_user = User.find_for_authentication(:subdomain => account.subdomain)
    authenicated_user.should == user
  end
end

describe User, ".valid_token?" do

  it "returns the user for the given token" do
    user = User.gen(:authentication_token => "12345")
    token_user = User.valid_token?("12345")
    token_user.should == user
  end
end

describe User, ".admin_live_search" do

  before do
    @shelter1 = Shelter.gen(:name => "oranges")
    @user1 = User.gen(:name => "helper", :email => "helper@se.test")

    @shelter2 = Shelter.gen(:name => "apples")
    @user2 = User.gen(:name => "saver", :email => "saver@se.test")

    @account1 = Account.gen(
      :users => [@user1],
      :shelters => [@shelter1]
    )

    @account2 = Account.gen(
      :users => [@user2],
      :shelters => [@shelter2]
    )
  end

  it "returns all users from the admin_list when no params" do
    admin_list = User.admin_live_search("")

    admin_list.count.should == 2

    list_user1 = admin_list[0]
    list_user1.email.should == "saver@se.test"
    list_user1.name.should == "saver"
    list_user1.shelter_id.should == @shelter2.id
    list_user1.shelter_name.should == "apples"

    list_user2 = admin_list[1]
    list_user2.email.should == "helper@se.test"
    list_user2.name.should == "helper"
    list_user2.shelter_id.should == @shelter1.id
    list_user2.shelter_name.should == "oranges"
  end

  it "returns all users with the email match" do
    admin_list = User.admin_live_search("saver@se")

    admin_list.count.should == 1

    list_user = admin_list[0]
    list_user.email.should == "saver@se.test"
    list_user.name.should == "saver"
    list_user.shelter_id.should == @shelter2.id
    list_user.shelter_name.should == "apples"
  end

  it "returns all users from the admin_list" do
    admin_list = User.admin_live_search("help")

    admin_list.count.should == 1

    list_user = admin_list[0]
    list_user.email.should == "helper@se.test"
    list_user.name.should == "helper"
    list_user.shelter_id.should == @shelter1.id
    list_user.shelter_name.should == "oranges"
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe User, "#account" do

  it "belongs to a account" do
    account = Account.gen
    user = User.gen :account => account

    user.account.should == account
  end

  it "should return a readonly shelter" do
    user = User.gen :account => Account.gen
    user.reload.account.should be_readonly
  end
end

describe User, "#shelter" do

  it "should have many shelters through an account" do
    shelter1 = Shelter.gen
    shelter2 = Shelter.gen
    user     = User.gen

    account  = Account.gen(
      :shelters => [shelter1, shelter2],
      :users => [user]
    )

    user.shelters.should =~ [shelter1, shelter2]
  end
end

describe User, "#first_name" do

  it "returns the user's first name" do
    user = User.new :name => "Jimmy Bob"
    user.first_name.should == "Jimmy"
  end
end

describe User, "#last_name" do

  it "returns the user's last name" do
    user = User.new :name => "Jimmy Bob"
    user.last_name.should == "Bob"
  end
end

describe User, "#is?(role)" do

  it "returns true if user is owner" do
    user = User.new :role => "owner"
    user.is?(:owner).should == true
    user.is?(:admin).should == false
    user.is?(:user).should  == false
  end

  it "returns true if user is admin" do
    user = User.new :role => "admin"
    user.is?(:owner).should == false
    user.is?(:admin).should == true
    user.is?(:user).should  == false
  end

  it "returns true if user is user" do
    user = User.new :role => "user"
    user.is?(:owner).should == false
    user.is?(:admin).should == false
    user.is?(:user).should  == true
  end
end

