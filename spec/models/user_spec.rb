require "spec_helper"


  #before_create :hide_announcements_by_default


  #devise :database_authenticatable, :recoverable, :token_authenticatable,
         #:rememberable, :trackable, :lockable, :invitable, :validatable,
         #:authentication_keys => [ :email, :subdomain ]
         ##:confirmable, :lockable

  ## Getters/Setters
  ##----------------------------------------------------------------------------
  #attr_accessible :name, :title, :email, :password, :password_confirmation, :authentication_token,
                  #:remember_me, :role, :account_id, :announcement_hide_time

  ## Class Methods
  ##----------------------------------------------------------------------------
  #def self.find_for_authentication(conditions={})
    #subdomain = conditions.delete(:subdomain)
    #self.select("users.*").joins(:account).where(conditions).where("accounts.subdomain = ?", subdomain).first
  #end

  #def self.valid_token?(token)
    #token_user = self.where(:authentication_token => token).first
    #if token_user
      #token_user.authentication_token = nil
      #token_user.save
    #end
    #return token_user
  #end

  #def self.admin_live_search(q)
    #scope = self.scoped
    #scope = scope.admin_list
    #scope = scope.where("users.name LIKE ? or users.email LIKE ?", "%#{q}%", "%#{q}%") unless q.blank?
    #scope
  #end


  ##----------------------------------------------------------------------------
  #private

  #def hide_announcements_by_default
    #self.announcement_hide_time = Time.now.utc
  #end
#end

describe User do

  it "should require presence of name" do
    user = User.new :name => nil
    user.should have(1).error_on(:name)
    user.errors[:name].should == ["cannot be blank"]
  end
end

# Constants
#----------------------------------------------------------------------------
describe User, "::ROLES" do
  it "should contain a default list of roles" do
    User::ROLES.should == ["user", "admin"]
  end
end

describe User, "::OWNER" do
  it "should contain the owner value" do
    User::OWNER.should == "owner"
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe User, "#account" do

  it "should belong to a account" do
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
  pending "not completed"
    account  = Account.gen
    shelter1 = Shelter.gen :account => account
    shelter2 = Shelter.gen :account => account
    user     = User.gen :account => account
p "Shelters :: #{user.shelters.collect(&:id)}"
    user.shelters.should =~ [shelter1, shelter2]
  end
end

describe User, "#first_name" do

  it "should return the user's first name" do
    user = User.new :name => "Jimmy Bob"
    user.first_name.should == "Jimmy"
  end
end

describe User, "#last_name" do

  it "should return the user's last name" do
    user = User.new :name => "Jimmy Bob"
    user.last_name.should == "Bob"
  end
end

describe User, "#is?(role)true" do

  it "should validate user as owner" do
    user = User.new :role => "owner"
    user.is?(:owner).should == true
    user.is?(:admin).should == false
    user.is?(:user).should  == false
  end

  it "should validate user as admin" do
    user = User.new :role => "admin"
    user.is?(:owner).should == false
    user.is?(:admin).should == true
    user.is?(:user).should  == false
  end

  it "should validate user as user" do
    user = User.new :role => "user"
    user.is?(:owner).should == false
    user.is?(:admin).should == false
    user.is?(:user).should  == true
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe User, ".owner" do

  it "should return all of the users that are role owner" do
    user1 = User.gen :role => "owner"
    user2 = User.gen :role => "admin"
    user3 = User.gen :role => "user"

    users = User.owner.all

    users.count.should == 1
    users.should       == [user1]
  end
end

describe User, ".admin" do

  it "should return all of the users that are role admin" do
    user1 = User.gen :role => "owner"
    user2 = User.gen :role => "admin"
    user3 = User.gen :role => "user"

    users = User.admin.all

    users.count.should == 1
    users.should       == [user2]
  end
end

describe User, ".default" do

  it "should return all of the users that are role user" do
    user1 = User.gen :role => "owner"
    user2 = User.gen :role => "admin"
    user3 = User.gen :role => "user"

    users = User.default.all

    users.count.should == 1
    users.should       == [user3]
  end
end

describe User, ".admin_list" do

  it "should return a list of names, emails, shelter ids, and shelter names" do
    pending "not completed"
  #scope :admin_list, joins(:shelters).
                     #select("users.name as name, users.email as email, shelters.id as shelter_id, shelters.name as shelter_name").
                     #order("shelters.name").limit(250)
  end

  it "should order the users by name" do
    pending "not completed"

  end

  it "should limit the amount of users returned" do
    pending "not completed"

  end
end

