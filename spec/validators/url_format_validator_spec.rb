require "rails_helper"

class UrlFormatValidatable
  include ActiveModel::Validations
  attr_accessor :url
  validates :url, :url_format => true
end

describe UrlFormatValidator do

  subject { UrlFormatValidatable.new }

  it "valid when correct format" do
    subject.url = "http://www.shelterexchange.org"
    expect(subject.valid?).to be_truthy
  end

  it "invalid without protocol" do
    subject.url = "www.shelterexchange.org"

    expect(subject.valid?).to be_falsey
    expect(subject.errors[:url].size).to eq(1)
    expect(subject.errors[:url]).to match_array(["format is incorrect"])
  end

  it "invalid without tld" do
    subject.url = "http://www.shelterexchange"

    expect(subject.valid?).to be_falsey
    expect(subject.errors[:url].size).to eq(1)
    expect(subject.errors[:url]).to match_array(["format is incorrect"])
  end
end
