require "spec_helper"

class TestIntegration < Integration; end;

describe Integration do

  context "Before Validation" do

    it "should clean the attribute values" do
      integration = Integration.gen :username => "    testing    ", :password => "   blah blah blah    "
      expect(integration.username).to eq("testing")
      expect(integration.password).to eq("blah blah blah")
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
    expect(integration).to be_instance_of(Integration)
    expect(integration.username).to eq("username")
    expect(integration.password).to eq("password")
  end

  it "returns a type class integration object" do
    integration = Integration.factory({ :type => "TestIntegration", :username => "username", :password => "password"})
    expect(integration).to be_instance_of(TestIntegration)
    expect(integration.username).to eq("username")
    expect(integration.password).to eq("password")
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Integration, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    integration = Integration.new :shelter => shelter

    expect(integration.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    integration = Integration.gen
    expect(integration.reload.shelter).to be_readonly
  end
end

