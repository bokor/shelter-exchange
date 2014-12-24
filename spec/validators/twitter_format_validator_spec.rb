require "rails_helper"

class TwitterFormatValidatable
  include ActiveModel::Validations
  attr_accessor :twitter
  validates :twitter, :twitter_format => true
end

describe TwitterFormatValidator do

  subject { TwitterFormatValidatable.new }

  it "valid when correct format" do
    subject.twitter = "@shelterexchange"
    expect(subject.valid?).to be_truthy
  end

  it "invalid when not correct format" do
    subject.twitter = "shelterexchange"

    expect(subject.valid?).to be_falsey
    expect(subject.errors[:twitter].size).to eq(1)
    expect(subject.errors[:twitter]).to match_array(["format is incorrect. Example @shelterexchange"])
  end
end
