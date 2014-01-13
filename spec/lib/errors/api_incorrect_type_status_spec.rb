require 'spec_helper'

describe Errors::ApiIncorrectTypeStatus do

  it "creates new api incorrect type status error" do
    Errors::ApiIncorrectTypeStatus.new.should be_kind_of StandardError
  end
end

