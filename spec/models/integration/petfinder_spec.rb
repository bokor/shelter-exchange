require "rails_helper"

describe Integration::Petfinder do

  before do
    allow(Net::FTP).to receive(:open).and_return(true)
  end

  it "validates presence of username" do
    integration = Integration::Petfinder.new :username => nil
    expect(integration.error_on(:username).size).to eq(1)
    expect(integration.errors[:username]).to match_array(["cannot be blank"])
  end

  it "validates uniqueness of username" do
    Integration.gen :petfinder, :username => "TEST"
    integration = Integration::Petfinder.new :username => "TEST"
    expect(integration.error_on(:username).size).to eq(1)
    expect(integration.errors[:username]).to match_array(["Already in use with another shelter's account"])
  end

  it "validates presence of password" do
    integration = Integration::Petfinder.new :password => nil
    expect(integration.error_on(:password).size).to eq(1)
    expect(integration.errors[:password]).to match_array(["cannot be blank"])
  end

  it "validates the connection is successful" do
    integration = Integration::Petfinder.new :password => "test", :username => "test"
    expect(integration.error_on(:connection_failed).size).to eq(0)
  end

  it "validates the connection is failed" do
    allow(Net::FTP).to receive(:open).and_raise(Net::FTPPermError)

    integration = Integration::Petfinder.new :password => "test", :username => "test"
    expect(integration.error_on(:connection_failed).size).to eq(1)
    expect(integration.errors[:connection_failed]).to match_array(["Petfinder FTP Username and/or FTP Password is incorrect.  Please Try again!"])
  end

  context "Before Save" do

    it "upcases username" do
      shelter = Shelter.gen
      integration = Integration::Petfinder.new :username => "test", :password => "test", :shelter => shelter
      integration.save!

      expect(integration.username).to eq("TEST")
    end
  end

  context "After Save" do
    it "enqueues a job to update remote animals" do
      shelter = Shelter.gen
      integration = Integration::Petfinder.new :username => "test", :password => "test", :shelter => shelter

      petfinder_job = PetfinderJob.new(shelter.id)

      allow(PetfinderJob).to receive(:new).and_return(petfinder_job)
      expect(Delayed::Job).to receive(:enqueue).with(PetfinderJob.new(shelter.id))

      integration.save!
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Integration::Petfinder, "::FTP_URL" do
  it "returns the ftp url for petfinder" do
    expect(Integration::Petfinder::FTP_URL).to eq("members.petfinder.com")
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Integration::Petfinder, ".model_name" do

  it "returns the model name" do
    expect(Integration::Petfinder.model_name).to eq("Integration")
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Integration::Petfinder, "#humanize" do

  it "returns a humanized name for the integration" do
    expect(Integration::Petfinder.new.humanize).to eq("Petfinder")
  end
end

describe Integration::Petfinder, "#to_s" do

  it "returns a string representation of the integration" do
    expect(Integration::Petfinder.new.to_s).to eq("petfinder")
  end
end

describe Integration::Petfinder, "#to_sym" do

  it "returns a symbol representation of the integration" do
    expect(Integration::Petfinder.new.to_sym).to eq(:petfinder)
  end
end

