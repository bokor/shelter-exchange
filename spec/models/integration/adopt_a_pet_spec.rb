require "spec_helper"

describe Integration::AdoptAPet do

  it "validates presence of username" do
    integration = Integration::AdoptAPet.new :username => nil
    integration.should have(1).error_on(:username)
    integration.errors[:username].should == ["cannot be blank"]
  end

  it "validates uniqueness of username" do
    Integration.gen(:adopt_a_pet, :username => "test")
    integration = Integration::AdoptAPet.new :username => "test"
    integration.should have(1).error_on(:username)
    integration.errors[:username].should == ["Already in use with another shelter's account"]
  end

  it "validates presence of password" do
    integration = Integration::AdoptAPet.new :password => nil
    integration.should have(1).error_on(:password)
    integration.errors[:password].should == ["cannot be blank"]
  end

  it "validates the connection is successful" do
    ftp = double(Net::FTP).as_null_object
    Net::FTP.should_receive(:open).and_return(true)

    integration = Integration::AdoptAPet.new :password => "test", :username => "test"
    integration.should have(0).error_on(:connection_failed)
  end

  it "validates the connection is failed" do
    ftp = double(Net::FTP).as_null_object
    Net::FTP.should_receive(:open).and_raise(Net::FTPPermError)

    integration = Integration::AdoptAPet.new :password => "test", :username => "test"
    integration.should have(1).error_on(:connection_failed)
    integration.errors[:connection_failed].should == ["Adopt a Pet FTP Username and/or FTP Password is incorrect.  Please Try again!"]
  end
end

# Constants
#----------------------------------------------------------------------------
describe Integration::AdoptAPet, "::FTP_URL" do
  it "returns the ftp url for adopt a pet" do
    Integration::AdoptAPet::FTP_URL.should == "autoupload.adoptapet.com"
  end
end

# Class Methods
#----------------------------------------------------------------------------

# Instance Methods
#----------------------------------------------------------------------------
describe Integration::AdoptAPet, "#humanize" do

  it "returns a humanized name for the integration" do
    integration = Integration::AdoptAPet.new
    integration.humanize.should == "Adopt a Pet"
  end
end

describe Integration::AdoptAPet, "#to_s" do

  it "returns a string representation of the integration" do
    integration = Integration::AdoptAPet.new
    integration.to_s.should == "adopt_a_pet"
  end
end

describe Integration::AdoptAPet, "#to_sym" do

  it "returns a symbol representation of the integration" do
    integration = Integration::AdoptAPet.new
    integration.to_sym.should == :adopt_a_pet
  end
end

