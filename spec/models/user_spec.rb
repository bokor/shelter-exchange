require "rails_helper"

describe User do

  it "requires presence of name" do
    user = User.new :name => nil

    expect(user.valid?).to be_falsey
    expect(user.errors[:name].size).to eq(1)
    expect(user.errors[:name]).to match_array(["cannot be blank"])
  end

  context "Before Create" do
    describe "#hide_announcements_by_default" do
      it "sets the default announcement hide time as now" do
        Timecop.freeze(Time.now)

        user = User.gen
        expect(user.announcement_hide_time).to eq(Time.now)
      end
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe User, "::ROLES" do
  it "contains a default list of roles" do
    expect(User::ROLES).to match_array(["user", "admin", "read_only"])
  end
end

describe User, "::OWNER" do
  it "contains the owner value" do
    expect(User::OWNER).to eq("owner")
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe User, ".admin_list" do

  it "returns an ordered list of user names, emails, shelter ids, and shelter names" do
    shelter1 = Shelter.gen(:name => "oranges")
    user1 = User.gen(:name => "helper", :email => "helper@se.test")

    shelter2 = Shelter.gen(:name => "apples")
    user2 = User.gen(:name => "saver", :email => "saver@se.test")

    Account.gen(
      :users => [user1],
      :shelters => [shelter1]
    )

    Account.gen(
      :users => [user2],
      :shelters => [shelter2]
    )

    admin_list = User.admin_list

    expect(admin_list.count).to eq(2)

    list_user1 = admin_list[0]
    expect(list_user1.email).to eq("saver@se.test")
    expect(list_user1.name).to eq("saver")
    expect(list_user1.shelter_id).to eq(shelter2.id)
    expect(list_user1.shelter_name).to eq("apples")

    list_user2 = admin_list[1]
    expect(list_user2.email).to eq("helper@se.test")
    expect(list_user2.name).to eq("helper")
    expect(list_user2.shelter_id).to eq(shelter1.id)
    expect(list_user2.shelter_name).to eq("oranges")
  end
end

describe User, ".find_for_authentication" do

  it "returns a user that matches the authentication criteria" do
    account = Account.gen
    user = account.users.first

    authenicated_user = User.find_for_authentication(:subdomain => account.subdomain)
    expect(authenicated_user).to eq(user)
  end
end

describe User, ".valid_token?" do

  it "returns the user for the given token" do
    user = User.gen(:authentication_token => "12345")
    token_user = User.valid_token?("12345")
    expect(token_user).to eq(user)
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

    expect(admin_list.count).to eq(2)

    list_user1 = admin_list[0]
    expect(list_user1.email).to eq("saver@se.test")
    expect(list_user1.name).to eq("saver")
    expect(list_user1.shelter_id).to eq(@shelter2.id)
    expect(list_user1.shelter_name).to eq("apples")

    list_user2 = admin_list[1]
    expect(list_user2.email).to eq("helper@se.test")
    expect(list_user2.name).to eq("helper")
    expect(list_user2.shelter_id).to eq(@shelter1.id)
    expect(list_user2.shelter_name).to eq("oranges")
  end

  it "returns all users with the email match" do
    admin_list = User.admin_live_search("saver@se")

    expect(admin_list.count).to eq(1)

    list_user = admin_list[0]
    expect(list_user.email).to eq("saver@se.test")
    expect(list_user.name).to eq("saver")
    expect(list_user.shelter_id).to eq(@shelter2.id)
    expect(list_user.shelter_name).to eq("apples")
  end

  it "returns all users from the admin_list" do
    admin_list = User.admin_live_search("help")

    expect(admin_list.count).to eq(1)

    list_user = admin_list[0]
    expect(list_user.email).to eq("helper@se.test")
    expect(list_user.name).to eq("helper")
    expect(list_user.shelter_id).to eq(@shelter1.id)
    expect(list_user.shelter_name).to eq("oranges")
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe User, "#account" do

  it "belongs to a account" do
    account = Account.gen
    user = User.gen :account => account

    expect(user.account).to eq(account)
  end

  it "should return a readonly shelter" do
    user = User.gen :account => Account.gen
    expect(user.reload.account).to be_readonly
  end
end

describe User, "#shelter" do

  it "should have many shelters through an account" do
    shelter1 = Shelter.gen
    shelter2 = Shelter.gen
    user = User.gen

    Account.gen(
      :shelters => [shelter1, shelter2],
      :users => [user]
    )

    expect(user.shelters).to match_array([shelter1, shelter2])
  end
end

describe User, "#first_name" do

  it "returns the user's first name" do
    user = User.new :name => "Jimmy Bob"
    expect(user.first_name).to eq("Jimmy")
  end
end

describe User, "#last_name" do

  it "returns the user's last name" do
    user = User.new :name => "Jimmy Bob"
    expect(user.last_name).to eq("Bob")
  end
end

describe User, "#is?(role)" do

  it "returns true if user is owner" do
    user = User.new :role => "owner"
    expect(user.is?(:owner)).to eq(true)
    expect(user.is?(:admin)).to eq(false)
    expect(user.is?(:user)).to eq(false)
  end

  it "returns true if user is admin" do
    user = User.new :role => "admin"
    expect(user.is?(:owner)).to eq(false)
    expect(user.is?(:admin)).to eq(true)
    expect(user.is?(:user)).to eq(false)
  end

  it "returns true if user is user" do
    user = User.new :role => "user"
    expect(user.is?(:owner)).to eq(false)
    expect(user.is?(:admin)).to eq(false)
    expect(user.is?(:user)).to eq(true)
  end
end

