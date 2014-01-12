require 'spec_helper'

describe ShelterExchange::Errors::ShelterInactive do

  it "allows creation of a new error" do
    ShelterExchange::Errors::ShelterInactive.new.should be_kind_of StandardError
  end
end

describe ShelterExchange::Errors::ApiIncorrectTypeStatus do

  it "allows creation of a new error" do
    ShelterExchange::Errors::ApiIncorrectTypeStatus.new.should be_kind_of StandardError
  end
end

