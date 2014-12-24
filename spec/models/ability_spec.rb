require "rails_helper"
require "cancan/matchers"

# Class Methods
#----------------------------------------------------------------------------
describe Ability do

  it "defaults to read_only when role doesn't match existing list" do
    expect_any_instance_of(Ability).to receive(:read_only)
    user = User.new :role => "blah_blah_blah"
    @ability = Ability.new(user)
  end

  it "can not manage anything by default" do
    user = User.new :role => "blah_blah_blah"
    @ability = Ability.new(user)
    expect(@ability).to_not be_able_to(:manage, :all)
  end
end

describe Ability, ".owner" do

  before do
    user = User.new :role => :owner
    @ability = Ability.new(user)
  end

  it "can manage everything" do
    expect(@ability).to be_able_to(:manage, :all)
  end
end

describe Ability, ".admin" do

  before do
    user = User.new :role => :admin
    @ability = Ability.new(user)
  end

  it "can manage everything" do
    expect(@ability).to be_able_to(:manage, :all)
  end

  it "can not to change the owner" do
    expect(@ability).to_not be_able_to(:change_owner, User)
  end
end

describe Ability, ".user" do

  before do
    user = User.new :role => :user
    @ability = Ability.new(user)
  end

  it "can read everything" do
    expect(@ability).to be_able_to(:read, :all)
  end

  it "can create everything" do
    expect(@ability).to be_able_to(:create, :all)
  end

  it "can update everything" do
    expect(@ability).to be_able_to(:update, :all)
  end

  it "can not attach a file to a note" do
    expect(@ability).to_not be_able_to(:attach_files, Note)
  end

  it "can not generate access token for the shelter" do
    expect(@ability).to_not be_able_to(:generate_access_token, Shelter)
  end

  it "can not invite a user" do
    expect(@ability).to_not be_able_to(:intive, User)
  end

  it "can not change the role a user" do
    expect(@ability).to_not be_able_to(:change_role, User)
  end

  it "can not view settings for a user" do
    expect(@ability).to_not be_able_to(:view_settings, User)
  end

  it "can not request a transfer of an animal" do
    expect(@ability).to_not be_able_to(:request_transfer, Animal)
  end

  it "can not export animals" do
    expect(@ability).to_not be_able_to(:export, Animal)
  end

  it "can not export contacts" do
    expect(@ability).to_not be_able_to(:export, Contact)
  end

  it "can not import contacts" do
    expect(@ability).to_not be_able_to(:import, Contact)
  end
end

describe Ability, ".read_only" do

  before do
    user = User.new :role => :read_only
    @ability = Ability.new(user)
  end

  it "can not manage anything" do
    expect(@ability).to_not be_able_to(:manage, :all)
  end

  it "can edit their user record" do
    expect(@ability).to be_able_to(:update, User)
  end
end

