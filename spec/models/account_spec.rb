require "rails_helper"

describe Account do

  it_should_behave_like Uploadable

  it "requires presence of subdomain" do
    account = Account.new :subdomain => nil

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(2)
    expect(account.errors[:subdomain]).to match_array([
      "cannot be blank",
      "can only contain letters, numbers, or hyphens.  No spaces allowed!"
    ])
  end

  it "requires uniqueness of subdomain" do
    Account.gen(:subdomain => "testing")
    account = Account.new :subdomain => "testing"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["has already been taken"])
  end

  it "requires format of subdomain containing only letters, numbers, or hyphens" do
    account = Account.new :subdomain => "testing_testing"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["can only contain letters, numbers, or hyphens.  No spaces allowed!"])

    account = Account.new :subdomain => "testing testing"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["can only contain letters, numbers, or hyphens.  No spaces allowed!"])
  end

  it "requires format of subdomain to start with a letter" do
    account = Account.new :subdomain => "007testing"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["has to start and end with a letter"])

    account = Account.new :subdomain => "---testing"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["has to start and end with a letter"])
  end

  it "requires format of subdomain to end with a letter or number" do
    account = Account.new :subdomain => "testing---"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["has to start and end with a letter"])

    account = Account.new :subdomain => "testing007"
    expect(account.errors[:subdomain].size).to eq(0)
  end

  it "requires format of subdomain not being a reserved name" do
    account = Account.new :subdomain => "www"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["is reserved and unavailable."])

    account = Account.new :subdomain => "admin"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["is reserved and unavailable."])

    account = Account.new :subdomain => "help"

    expect(account.valid?).to be_falsey
    expect(account.errors[:subdomain].size).to eq(1)
    expect(account.errors[:subdomain]).to match_array(["is reserved and unavailable."])
  end

  it "requires inclusion of document type" do
    account = Account.gen(:document_type => "document_type")

    expect(account.valid?).to be_falsey
    expect(account.errors[:document_type].size).to eq(1)
    expect(account.errors[:document_type]).to match_array(["is not included in the list"])
  end

  it "require presence of a document" do
    account = Account.gen(:document => nil)

    expect(account.valid?).to be_falsey
    expect(account.errors[:document].size).to eq(1)
    expect(account.errors[:document]).to match_array(["cannot be blank"])
  end

  context "Before Create" do

    describe "#downcase_subdomain" do
      it "downcases the subdomain" do
        account = Account.new(:subdomain => "TESTING")
        expect(account.subdomain).to eq("TESTING")
        account.save(:validate => false)
        expect(account.subdomain).to eq("testing")
      end
    end
  end

  context "Nested Attributes" do

    it "accepts nested attributes for users" do
      expect(Account.count).to eq(0)
      expect(User.count).to   eq(0)

      Account.gen :users_attributes => [User.attributes, User.attributes]

      expect(Account.count).to eq(1)
      expect(User.count).to eq(2)
    end

    it "accepts nested attributes for shelters" do
      expect(Account.count).to eq(0)
      expect(Shelter.count).to eq(0)

      Account.gen :shelters_attributes => [Shelter.attributes, Shelter.attributes]

      expect(Account.count).to eq(1)
      expect(Shelter.count).to eq(2)
    end
  end

  context "Mount Uploader" do

    it "returns an attachment uploader for the document" do
      account = Account.gen
      expect(account.document).to be_kind_of(AttachmentUploader)
    end
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
    expect(@account.shelters.count).to eq(2)
    expect(@account.shelters).to match_array([@shelter1, @shelter2])
  end

  it "destroys the shelters when an account is deleted" do
    expect(Shelter.count).to eq(2)
    @account.destroy
    expect(Shelter.count).to eq(0)
  end
end

describe Account, "#users" do

  before do
    @user1 = User.gen
    @user2 = User.gen

    @account = Account.gen(:users => [@user1,@user2])
  end

  it "has many users" do
    expect(@account.users.count).to eq(2)
    expect(@account.users).to match_array([@user1, @user2])
  end

  it "destroys the users when an account is deleted" do
    expect(User.count).to eq(2)
    @account.destroy
    expect(User.count).to eq(0)
  end
end

