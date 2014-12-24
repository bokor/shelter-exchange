require "rails_helper"

class VideoUrlFormatValidatable
  include ActiveModel::Validations
  attr_accessor :url
  validates :url, :video_url_format => true
end

describe VideoUrlFormatValidator do

  subject { VideoUrlFormatValidatable.new }

  it "valid when correct format with watch" do
    subject.url = "http://www.youtube.com/watch?v=1234"
    expect(subject).to be_valid
  end

  it "valid when correct format with embed" do
    subject.url = "http://www.youtube.com/embed/1234"
    expect(subject).to be_valid
  end

  it "valid when correct format with user" do
    subject.url = "http://www.youtube.com/user/1234"
    expect(subject).to be_valid
  end

  it "valid when correct format with short link" do
    subject.url = "http://youtu.be/1234"
    expect(subject).to be_valid
  end

  it "invalid without protocol" do
    subject.url = "www.shelterexchange.org"

    expect(subject).not_to be_valid
    expect(subject.error_on(:url).size).to eq(1)
    expect(subject.errors[:url]).to match_array(["incorrect You Tube URL format"])
  end
end
