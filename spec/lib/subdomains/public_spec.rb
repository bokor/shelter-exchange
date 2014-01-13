require "spec_helper"

describe Subdomains::Public, ".matches?" do

  it "returns true when matches www subdomain" do
    request = OpenStruct.new(:subdomain => "www")
    Subdomains::Public.matches?(request).should be_true
  end

  it "returns true when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    Subdomains::Public.matches?(request).should be_true
  end

  it "returns false when doesn't match subdomain" do
    request = OpenStruct.new(:subdomain => "api")
    Subdomains::Public.matches?(request).should be_false
  end
end

