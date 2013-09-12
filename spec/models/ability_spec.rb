require "spec_helper"
require "cancan/matchers"

# Class Methods
#----------------------------------------------------------------------------
describe Ability, ".owner" do

  before do
    user = User.new :role => :owner
    @ability = Ability.new(user)
  end

  it "can manage everything" do
    @ability.should be_able_to(:manage, :all)
  end
end

describe Ability, ".admin" do

  before do
    user = User.new :role => :admin
    @ability = Ability.new(user)
  end

  it "can manage everything" do
    @ability.should be_able_to(:manage, :all)
  end

  it "can not to change the owner" do
    @ability.should_not be_able_to(:change_owner, User)
  end
end

describe Ability, ".user" do

  before do
    user = User.new :role => :user
    @ability = Ability.new(user)
  end

  it "can read everything" do
    @ability.should be_able_to(:read, :all)
  end

  it "can create everything" do
    @ability.should be_able_to(:create, :all)
  end

  it "can update everything" do
    @ability.should be_able_to(:update, :all)
  end

  it "can not attach a file to a note" do
    @ability.should_not be_able_to(:attach_files, Note)
  end

  it "can not generate access token for the shelter" do
    @ability.should_not be_able_to(:generate_access_token, Shelter)
  end

  it "can not invite a user" do
    @ability.should_not be_able_to(:intive, User)
  end

  it "can not change the role a user" do
    @ability.should_not be_able_to(:change_role, User)
  end

  it "can not view settings for a user" do
    @ability.should_not be_able_to(:view_settings, User)
  end

  it "can not request a transfer of an animal" do
    @ability.should_not be_able_to(:request_transfer, Animal)
  end
end

