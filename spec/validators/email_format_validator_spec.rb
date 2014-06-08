require "spec_helper"

class EmailFormatValidatable
  include ActiveModel::Validations
  attr_accessor :email
  validates :email, :email_format => true
end

describe EmailFormatValidator do

  subject { EmailFormatValidatable.new }

  it "valid when blank record" do
    subject.email = ""
    expect(subject).to be_valid
  end

  it "valid when correct format" do
    subject.email = "brian@bokor.com"
    expect(subject).to be_valid
  end

  it "valid when correct format with 2 level domain" do
    subject.email = "brian@bokor.co.uk"
    expect(subject).to be_valid
  end

  it "invalid when format does not contain an @ symbol" do
    subject.email = "aaaabbbb.com"
    expect(subject).not_to be_valid
    expect(subject).to have(1).error_on(:email)
    expect(subject.errors[:email]).to match_array(["format is incorrect"])
  end

  it "invalid when format contains incorrect symbols after @" do
    subject.email = "brian@brian(*)bokor.com"
    expect(subject).not_to be_valid
    expect(subject).to have(1).error_on(:email)
    expect(subject.errors[:email]).to match_array(["format is incorrect"])
  end
end
