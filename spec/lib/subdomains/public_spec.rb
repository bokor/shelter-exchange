require "spec_helper"

describe Subdomains::Public, ".matches?" do

  it "returns true when matches www subdomain" do
    request = OpenStruct.new(:subdomain => "www")
    expect(Subdomains::Public.matches?(request)).to be_true
  end

  it "returns true when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    expect(Subdomains::Public.matches?(request)).to be_true
  end

  it "returns false when doesn't match subdomain" do
    request = OpenStruct.new(:subdomain => "api")
    expect(Subdomains::Public.matches?(request)).to be_false
  end
end

