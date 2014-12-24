require "rails_helper"

class PhoneFormatValidatable
  include ActiveModel::Validations
  attr_accessor :phone
  validates :phone, :phone_format => true
end

describe PhoneFormatValidator do

  subject { PhoneFormatValidatable.new }

  it "valid when correct format" do
    subject.phone = "123-456-7890"
    expect(subject.valid?).to be_truthy
  end

  it "invalid when not correct format" do
    subject.phone = "a123-456-7890"

    expect(subject.valid?).to be_falsey
    expect(subject.errors[:phone].size).to eq(1)
    expect(subject.errors[:phone]).to match_array(["invalid phone number format"])
  end
end
