require "rails_helper"

describe Subdomains::Api, ".matches?" do

  it "returns true when matches api subdomain" do
    request = OpenStruct.new(:subdomain => "api")
    expect(Subdomains::Api.matches?(request)).to be_truthy
  end

  it "returns false when does not match subdomain list" do
    request = OpenStruct.new(:subdomain => "www")
    expect(Subdomains::Api.matches?(request)).to be_falsey
  end

  it "returns false when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    expect(Subdomains::Api.matches?(request)).to be_falsey
  end
end

