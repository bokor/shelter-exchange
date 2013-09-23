require "spec_helper"

class TestIntegration < Integration; end;

describe Integration do

  context "Before Validation" do

    it "should clean the attribute values" do
      integration = Integration.gen :username => "    testing    ", :password => "   blah blah blah    "
      integration.username.should == "testing"
      integration.password.should == "blah blah blah"
    end
  end
end

# Constants
#----------------------------------------------------------------------------

# Class Methods
#----------------------------------------------------------------------------
describe Integration, ".factory" do

  it "returns an integration object" do
    integration = Integration.factory({:username => "username", :password => "password"})
    integration.should be_instance_of(Integration)
    integration.username.should == "username"
    integration.password.should == "password"
  end

  it "returns a type class integration object" do
    integration = Integration.factory({ :type => "TestIntegration", :username => "username", :password => "password"})
    integration.should be_instance_of(TestIntegration)
    integration.username.should == "username"
    integration.password.should == "password"
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Integration, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    integration = Integration.new :shelter => shelter

    integration.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    integration = Integration.gen
    integration.reload.shelter.should be_readonly
  end
end

