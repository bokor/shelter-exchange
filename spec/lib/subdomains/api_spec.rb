require "spec_helper"

describe Subdomains::Api, ".matches?" do

  it "returns true when matches api subdomain" do
    request = OpenStruct.new(:subdomain => "api")
    Subdomains::Api.matches?(request).should be_true
  end

  it "returns false when does not match subdomain list" do
    request = OpenStruct.new(:subdomain => "www")
    Subdomains::Api.matches?(request).should be_false
  end

  it "returns false when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    Subdomains::Api.matches?(request).should be_false
  end
end

