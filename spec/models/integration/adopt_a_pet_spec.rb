require "rails_helper"

describe Integration::AdoptAPet do

  before do
    allow(Net::FTP).to receive(:open).and_return(true)
  end

  it "validates presence of username" do
    integration = Integration::AdoptAPet.new :username => nil
    expect(integration.error_on(:username).size).to eq(1)
    expect(integration.errors[:username]).to match_array(["cannot be blank"])
  end

  it "validates uniqueness of username" do
    Integration.gen :adopt_a_pet, :username => "test"
    integration = Integration::AdoptAPet.new :username => "test"
    expect(integration.error_on(:username).size).to eq(1)
    expect(integration.errors[:username]).to match_array(["Already in use with another shelter's account"])
  end

  it "validates presence of password" do
    integration = Integration::AdoptAPet.new :password => nil
    expect(integration.error_on(:password).size).to eq(1)
    expect(integration.errors[:password]).to match_array(["cannot be blank"])
  end

  it "validates the connection is successful" do
    integration = Integration::AdoptAPet.new :password => "test", :username => "test"
    expect(integration.error_on(:connection_failed).size).to eq(0)
  end

  it "validates the connection is failed" do
    allow(Net::FTP).to receive(:open).and_raise(Net::FTPPermError)

    integration = Integration::AdoptAPet.new :password => "test", :username => "test"
    expect(integration.error_on(:connection_failed).size).to eq(1)
    expect(integration.errors[:connection_failed]).to match_array(["Adopt a Pet FTP Username and/or FTP Password is incorrect.  Please Try again!"])
  end

  context "After Save" do
    it "enqueues a job to update remote animals" do
      shelter = Shelter.gen
      integration = Integration::AdoptAPet.new :username => "test", :password => "test", :shelter => shelter
      adopt_a_pet_job = AdoptAPetJob.new(shelter.id)

      allow(AdoptAPetJob).to receive(:new).and_return(adopt_a_pet_job)
      expect(Delayed::Job).to receive(:enqueue).with(AdoptAPetJob.new(shelter.id))

      integration.save!
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Integration::AdoptAPet, "::FTP_URL" do
  it "returns the ftp url for adopt a pet" do
    expect(Integration::AdoptAPet::FTP_URL).to eq("autoupload.adoptapet.com")
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Integration::AdoptAPet, ".model_name" do

  it "returns the model name" do
    expect(Integration::AdoptAPet.model_name).to eq("Integration")
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Integration::AdoptAPet, "#humanize" do

  it "returns a humanized name for the integration" do
    expect(Integration::AdoptAPet.new.humanize).to eq("Adopt a Pet")
  end
end

describe Integration::AdoptAPet, "#to_s" do

  it "returns a string representation of the integration" do
    expect(Integration::AdoptAPet.new.to_s).to eq("adopt_a_pet")
  end
end

describe Integration::AdoptAPet, "#to_sym" do

  it "returns a symbol representation of the integration" do
    expect(Integration::AdoptAPet.new.to_sym).to eq(:adopt_a_pet)
  end
end

