require 'rails_helper'

describe Errors::ApiIncorrectTypeStatus do

  it "creates new api incorrect type status error" do
    expect(Errors::ApiIncorrectTypeStatus.new).to be_kind_of StandardError
  end
end

