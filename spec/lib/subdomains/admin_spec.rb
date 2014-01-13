require "spec_helper"

describe Subdomains::Admin, ".matches?" do

  it "returns true when matches manage subdomain" do
    request = OpenStruct.new(:subdomain => "manage")
    Subdomains::Admin.matches?(request).should be_true
  end

  it "returns true when matches admin subdomain" do
    request = OpenStruct.new(:subdomain => "admin")
    Subdomains::Admin.matches?(request).should be_true
  end

  it "returns false when does not match subdomain list" do
    request = OpenStruct.new(:subdomain => "www")
    Subdomains::Admin.matches?(request).should be_false
  end

  it "returns false when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    Subdomains::Admin.matches?(request).should be_false
  end
end

