require 'spec_helper'

describe ShelterExchange::Subdomains::Admin, ".matches?" do

  it "returns true when matches manage subdomain" do
    request = OpenStruct.new(:subdomain => "manage")
    ShelterExchange::Subdomains::Admin.matches?(request).should be_true
  end

  it "returns true when matches admin subdomain" do
    request = OpenStruct.new(:subdomain => "admin")
    ShelterExchange::Subdomains::Admin.matches?(request).should be_true
  end

  it "returns false when does not match subdomain list" do
    request = OpenStruct.new(:subdomain => "www")
    ShelterExchange::Subdomains::Admin.matches?(request).should be_false
  end

  it "returns false when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    ShelterExchange::Subdomains::Admin.matches?(request).should be_false
  end
end

describe ShelterExchange::Subdomains::Api, ".matches?" do

  it "returns true when matches api subdomain" do
    request = OpenStruct.new(:subdomain => "api")
    ShelterExchange::Subdomains::Api.matches?(request).should be_true
  end

  it "returns false when does not match subdomain list" do
    request = OpenStruct.new(:subdomain => "www")
    ShelterExchange::Subdomains::Api.matches?(request).should be_false
  end

  it "returns false when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    ShelterExchange::Subdomains::Api.matches?(request).should be_false
  end
end

describe ShelterExchange::Subdomains::App, ".matches?" do

  it "returns true when doesn't match reserved subdomain" do
    request = OpenStruct.new(:subdomain => "brian", :subdomains => ["brian"])
    ShelterExchange::Subdomains::App.matches?(request).should be_true
  end

  it "returns false when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomains => [nil])
    ShelterExchange::Subdomains::App.matches?(request).should be_false
  end

  it "returns false when matches a reserved subdomain" do
    RESERVED_SUBDOMAINS.each do |subdomain|
      request = OpenStruct.new(:subdomains => [subdomain])
      ShelterExchange::Subdomains::App.matches?(request).should be_false
    end
  end
end

describe ShelterExchange::Subdomains::Public, ".matches?" do

  it "returns true when matches www subdomain" do
    request = OpenStruct.new(:subdomain => "www")
    ShelterExchange::Subdomains::Public.matches?(request).should be_true
  end

  it "returns true when request doesn't contain a subdomain" do
    request = OpenStruct.new(:subdomain => nil)
    ShelterExchange::Subdomains::Public.matches?(request).should be_true
  end

  it "returns false when doesn't match subdomain" do
    request = OpenStruct.new(:subdomain => "api")
    ShelterExchange::Subdomains::Public.matches?(request).should be_false
  end
end

