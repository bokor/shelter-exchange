require 'spec_helper'

describe ShelterExchange::Errors::ShelterInactive do

  it "creates new shelter inactive error" do
    ShelterExchange::Errors::ShelterInactive.new.should be_kind_of StandardError
  end
end

describe ShelterExchange::Errors::ApiIncorrectTypeStatus do

  it "creates new api incorrect type status error" do
    ShelterExchange::Errors::ApiIncorrectTypeStatus.new.should be_kind_of StandardError
  end
end

