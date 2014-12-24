require 'rails_helper'

describe Errors::ShelterInactive do

  it "creates new shelter inactive error" do
    expect(Errors::ShelterInactive.new).to be_kind_of StandardError
  end
end

