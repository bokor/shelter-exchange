require "spec_helper"

describe Subdomains::App, ".matches?" do

  it "returns true when doesn't match reserved subdomain" do
    request = OpenStruct.new(:subdomain => "brian", :subdomains => ["brian"])
    Subdomains::App.matches?(request).should be_true
  end

  it "returns false when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomains => [nil])
    Subdomains::App.matches?(request).should be_false
  end

  it "returns false when matches a reserved subdomain" do
    RESERVED_SUBDOMAINS.each do |subdomain|
      request = OpenStruct.new(:subdomains => [subdomain])
      Subdomains::App.matches?(request).should be_false
    end
  end
end

