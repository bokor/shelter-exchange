require "rails_helper"

describe Subdomains::Admin, ".matches?" do

  it "returns true when matches manage subdomain" do
    request = OpenStruct.new(:subdomain => "manage")
    expect(Subdomains::Admin.matches?(request)).to be_truthy
  end

  it "returns true when matches admin subdomain" do
    request = OpenStruct.new(:subdomain => "admin")
    expect(Subdomains::Admin.matches?(request)).to be_truthy
  end

  it "returns false when does not match subdomain list" do
    request = OpenStruct.new(:subdomain => "www")
    expect(Subdomains::Admin.matches?(request)).to be_falsey
  end

  it "returns false when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    expect(Subdomains::Admin.matches?(request)).to be_falsey
  end
end

