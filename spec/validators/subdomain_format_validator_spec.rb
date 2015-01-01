require "rails_helper"

class SubdomainFormatValidatable
  include ActiveModel::Validations
  attr_accessor :subdomain
  validates :subdomain, :subdomain_format => true
end

describe SubdomainFormatValidator do

  subject { SubdomainFormatValidatable.new }

  it "valid when correct format, containing only letters, numbers and hyphens" do
    subject.subdomain = "brian-bokor-007"
    expect(subject.valid?).to be_truthy
  end

  it "invalid when containing other than letters, numbers and hyphens" do
    subject.subdomain = "brian_bokor"

    expect(subject.valid?).to be_falsey
    expect(subject.errors[:subdomain].size).to eq(1)
    expect(subject.errors[:subdomain]).to match_array(["can only contain letters, numbers, or hyphens.  No spaces allowed!"])
  end

  it "invalid when does not start or end with a letter" do
    subject.subdomain = "007-brian-bokor"

    expect(subject.valid?).to be_falsey
    expect(subject.errors[:subdomain].size).to eq(1)
    expect(subject.errors[:subdomain]).to match_array(["has to start and end with a letter"])
  end

  it "invalid when the subdomain matches a reserved name" do
    subject.subdomain = "blog"

    expect(subject.valid?).to be_falsey
    expect(subject.errors[:subdomain].size).to eq(1)
    expect(subject.errors[:subdomain]).to match_array(["is reserved and unavailable."])
  end
end
