require 'spec_helper'

describe String, "#is_numeric?" do

  it "returns true if the string is a number" do
    string = "1234".is_numeric?
    expect(string).to be_true
  end

  it "returns false if the string is not a number" do
    string = "test".is_numeric?
    expect(string).to be_false
  end
end

describe String, "#possessive" do

  it "returns string with possessive added when ends in s" do
    string = "dogs".possessive
    expect(string).to eq("dogs'")
  end

  it "returns string with possessive added when does not end in s" do
    string = "test".possessive
    expect(string).to eq("test's")
  end
end

describe String, "#to_boolean" do

  it "returns nil when doesn't match boolean string" do
    string = "test".to_boolean
    expect(string).to be_nil
  end

  it "returns true when string is true" do
    string = "true".to_boolean
    expect(string).to be_true
  end

  it "returns true when string is 1" do
    string = "1".to_boolean
    expect(string).to be_true
  end

  it "returns true when string is yes" do
    string = "yes".to_boolean
    expect(string).to be_true
  end

  it "returns true when string is on" do
    string = "on".to_boolean
    expect(string).to be_true
  end

  it "returns false when string is false" do
    string = "false".to_boolean
    expect(string).to be_false
  end

  it "returns false when string is 0" do
    string = "0".to_boolean
    expect(string).to be_false
  end

  it "returns false when string is no" do
    string = "no".to_boolean
    expect(string).to be_false
  end

  it "returns false when string is off" do
    string = "off".to_boolean
    expect(string).to be_false
  end
end

