require "spec_helper"

describe Integration::Petfinder do

  it "validates presence of username" do
    integration = Integration::Petfinder.new :username => nil
    integration.should have(1).error_on(:username)
    integration.errors[:username].should == ["cannot be blank"]
  end

  it "validates uniqueness of username" do
    Integration.gen(:petfinder, :username => "test")
    integration = Integration::Petfinder.new :username => "test"
    integration.should have(1).error_on(:username)
    integration.errors[:username].should == ["Already in use with another shelter's account"]
  end

  it "validates presence of password" do
    integration = Integration::Petfinder.new :password => nil
    integration.should have(1).error_on(:password)
    integration.errors[:password].should == ["cannot be blank"]
  end

  it "validates the connection is successful" do
    ftp = double(Net::FTP).as_null_object
    Net::FTP.should_receive(:open).and_return(true)

    integration = Integration::Petfinder.new :password => "test", :username => "test"
    integration.should have(0).error_on(:connection_failed)
  end

  it "validates the connection is failed" do
    ftp = double(Net::FTP).as_null_object
    Net::FTP.should_receive(:open).and_raise(Net::FTPPermError)

    integration = Integration::Petfinder.new :password => "test", :username => "test"
    integration.should have(1).error_on(:connection_failed)
    integration.errors[:connection_failed].should == ["Petfinder FTP Username and/or FTP Password is incorrect.  Please Try again!"]
  end

  context "Before Save" do

    it "upcases username" do
      ftp = double(Net::FTP).as_null_object
      Net::FTP.should_receive(:open).and_return(true)

      integration = Integration::Petfinder.new :username => "test", :password => "test"
      integration.save!
      integration.username.should == "TEST"
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Integration::Petfinder, "::FTP_URL" do
  it "returns the ftp url for petfinder" do
    Integration::Petfinder::FTP_URL.should == "members.petfinder.com"
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Integration::Petfinder, ".model_name" do

  it "returns the model name" do
    Integration::Petfinder.model_name.should == "Integration"
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Integration::Petfinder, "#humanize" do

  it "returns a humanized name for the integration" do
    integration = Integration::Petfinder.new
    integration.humanize.should == "Petfinder"
  end
end

describe Integration::Petfinder, "#to_s" do

  it "returns a string representation of the integration" do
    integration = Integration::Petfinder.new
    integration.to_s.should == "petfinder"
  end
end

describe Integration::Petfinder, "#to_sym" do

  it "returns a symbol representation of the integration" do
    integration = Integration::Petfinder.new
    integration.to_sym.should == :petfinder
  end
end

