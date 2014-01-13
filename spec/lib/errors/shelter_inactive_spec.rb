require 'spec_helper'

describe Errors::ShelterInactive do

  it "creates new shelter inactive error" do
    Errors::ShelterInactive.new.should be_kind_of StandardError
  end
end

