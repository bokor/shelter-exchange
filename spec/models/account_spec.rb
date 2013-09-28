require "spec_helper"

describe Account do

  it_should_behave_like Uploadable

  it "requires presence of subdomain" do
    account = Account.new :subdomain => nil
    account.should have(2).error_on(:subdomain)
    account.errors[:subdomain].should == [
      "cannot be blank",
      "can only contain letters, numbers, or hyphens.  No spaces allowed!"
    ]
  end

  it "requires uniqueness of subdomain" do
    Account.gen(:subdomain => "testing")
    account = Account.new :subdomain => "testing"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["has already been taken"]
  end

  it "requires format of subdomain containing only letters, numbers, or hyphens" do
    account = Account.new :subdomain => "testing_testing"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["can only contain letters, numbers, or hyphens.  No spaces allowed!"]

    account = Account.new :subdomain => "testing testing"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["can only contain letters, numbers, or hyphens.  No spaces allowed!"]
  end

  it "requires format of subdomain to start with a letter" do
    account = Account.new :subdomain => "007testing"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["has to start and end with a letter"]

    account = Account.new :subdomain => "---testing"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["has to start and end with a letter"]
  end

  it "requires format of subdomain to end with a letter or number" do
    account = Account.new :subdomain => "testing---"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["has to start and end with a letter"]

    account = Account.new :subdomain => "testing007"
    account.should have(0).error_on(:subdomain)
  end

  it "requires format of subdomain not being a reserved name" do
    account = Account.new :subdomain => "www"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["is reserved and unavailable."]

    account = Account.new :subdomain => "admin"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["is reserved and unavailable."]

    account = Account.new :subdomain => "help"
    account.should have(1).error_on(:subdomain)
    account.errors[:subdomain].should == ["is reserved and unavailable."]
  end

  it "requires inclusion of document type" do
    account = Account.gen(:document_type => "document_type")
    account.should have(1).error_on(:document_type)
    account.errors[:document_type].should == ["is not included in the list"]
  end

  it "require presence of a document" do
    account = Account.gen(:document => nil)
    account.should have(1).error_on(:document)
    account.errors[:document].should == ["cannot be blank"]
  end

  context "Before Create" do

    it "downcases the subdomain" do
      account = Account.new(:subdomain => "TESTING")
      account.subdomain.should == "TESTING"
      account.save(:validate => false)
      account.subdomain.should == "testing"
    end
  end

  context "Nested Attributes" do

    it "accepts nested attributes for users" do
      Account.count.should == 0
      User.count.should   == 0

      Account.gen :users_attributes => [User.attributes, User.attributes]

      Account.count.should == 1
      User.count.should == 2
    end

    it "accepts nested attributes for shelters" do
      Account.count.should == 0
      Shelter.count.should == 0

      Account.gen :shelters_attributes => [Shelter.attributes, Shelter.attributes]

      Account.count.should == 1
      Shelter.count.should == 2
    end
  end

  context "Mount Uploader" do

    it "returns an attachment uploader for the document" do
      account = Account.gen
      account.document.should be_kind_of(AttachmentUploader)
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Account, "::DOCUMENT_TYPE" do
  it "contains an array of document type values" do
    Account::DOCUMENT_TYPE.should == ["501(c)(3) determination letter", "990 tax form", "Your adoption contract"]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Account, "#shelters" do

  before do
    @shelter1 = Shelter.gen
    @shelter2 = Shelter.gen

    @account = Account.gen(
      :shelters => [@shelter1,@shelter2]
    )
  end

  it "has many shelters" do
    @account.shelters.count.should == 2
    @account.shelters.should       =~ [@shelter1, @shelter2]
  end

  it "destroys the shelters when an account is deleted" do
    Shelter.count.should == 2
    @account.destroy
    Shelter.count.should == 0
  end
end

describe Account, "#users" do

  before do
    @user1 = User.gen
    @user2 = User.gen

    @account = Account.gen(:users => [@user1,@user2])
  end

  it "has many users" do
    @account.users.count.should == 2
    @account.users.should =~ [@user1, @user2]
  end

  it "destroys the users when an account is deleted" do
    User.count.should == 2
    @account.destroy
    User.count.should == 0
  end
end
