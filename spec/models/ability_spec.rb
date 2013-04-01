require "spec_helper"
require "cancan/matchers"

describe Ability, ".owner" do

  before do
    user = User.gen :role => :owner
    @ability = Ability.new(user)
  end

  it "should be able to manage everything" do
    @ability.should be_able_to(:manage, :all)
  end
end

describe Ability, ".admin" do

  before do
    user = User.gen :role => :admin
    @ability = Ability.new(user)
  end

  it "should be able to manager everything" do
    @ability.should be_able_to(:manage, :all)
  end

  it "should not be able to change the owner" do
    @ability.should_not be_able_to(:change_owner, User)
  end
end

describe Ability, ".user" do

  before do
    user = User.gen :role => :user
    @ability = Ability.new(user)
  end

  it "should be able to read everything" do
    @ability.should be_able_to(:read, :all)
  end

  it "should be able to create everything" do
    @ability.should be_able_to(:create, :all)
  end

  it "should be able to update everything" do
    @ability.should be_able_to(:update, :all)
  end

  it "should not be able to update a shelter" do
    @ability.should_not be_able_to(:update, Shelter)
  end

  it "should not be able to generate access token for the shelter" do
    @ability.should_not be_able_to(:generate_access_token, Shelter)
  end

  it "should not be able to invite a user" do
    @ability.should_not be_able_to(:intive, User)
  end

  it "should not be able to change the role a user" do
    @ability.should_not be_able_to(:change_role, User)
  end

  it "should not be able to view settings for a user" do
    @ability.should_not be_able_to(:view_settings, User)
  end

  it "should not be able to request a transfer of an animal" do
    @ability.should_not be_able_to(:request_transfer, Animal)
  end
end

