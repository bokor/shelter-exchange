require "spec_helper"

class TwitterFormatValidatable
  include ActiveModel::Validations
  attr_accessor :twitter
  validates :twitter, :twitter_format => true
end

describe TwitterFormatValidator do

  subject { TwitterFormatValidatable.new }

  it "valid when correct format" do
    subject.twitter = "@shelterexchange"
    expect(subject).to be_valid
  end

  it "invalid when not correct format" do
    subject.twitter = "shelterexchange"
    expect(subject).not_to be_valid
    expect(subject).to have(1).error_on(:twitter)
    expect(subject.errors[:twitter]).to match_array(["format is incorrect. Example @shelterexchange"])
  end
end
