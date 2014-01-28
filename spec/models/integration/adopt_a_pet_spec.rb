require "spec_helper"

describe Integration::AdoptAPet do

  it "validates presence of username" do
    integration = Integration::AdoptAPet.new :username => nil
    expect(integration).to have(1).error_on(:username)
    expect(integration.errors[:username]).to match_array(["cannot be blank"])
  end

  it "validates uniqueness of username" do
    Integration.gen(:adopt_a_pet, :username => "test")
    integration = Integration::AdoptAPet.new :username => "test"
    expect(integration).to have(1).error_on(:username)
    expect(integration.errors[:username]).to match_array(["Already in use with another shelter's account"])
  end

  it "validates presence of password" do
    integration = Integration::AdoptAPet.new :password => nil
    expect(integration).to have(1).error_on(:password)
    expect(integration.errors[:password]).to match_array(["cannot be blank"])
  end

  it "validates the connection is successful" do
    double(Net::FTP).as_null_object
    Net::FTP.should_receive(:open).and_return(true)

    integration = Integration::AdoptAPet.new :password => "test", :username => "test"
    expect(integration).to have(0).error_on(:connection_failed)
  end

  it "validates the connection is failed" do
    double(Net::FTP).as_null_object
    Net::FTP.should_receive(:open).and_raise(Net::FTPPermError)

    integration = Integration::AdoptAPet.new :password => "test", :username => "test"
    expect(integration).to have(1).error_on(:connection_failed)
    expect(integration.errors[:connection_failed]).to match_array(["Adopt a Pet FTP Username and/or FTP Password is incorrect.  Please Try again!"])
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

