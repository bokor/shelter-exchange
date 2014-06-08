require "spec_helper"

class UrlFormatValidatable
  include ActiveModel::Validations
  attr_accessor :url
  validates :url, :url_format => true
end

describe UrlFormatValidator do

  subject { UrlFormatValidatable.new }

  it "valid when correct format" do
    subject.url = "http://www.shelterexchange.org"
    expect(subject).to be_valid
  end

  it "invalid without protocol" do
    subject.url = "www.shelterexchange.org"

    expect(subject).not_to be_valid
    expect(subject).to have(1).error_on(:url)
    expect(subject.errors[:url]).to match_array(["format is incorrect"])
  end

  it "invalid without tld" do
    subject.url = "http://www.shelterexchange"

    expect(subject).not_to be_valid
    expect(subject).to have(1).error_on(:url)
    expect(subject.errors[:url]).to match_array(["format is incorrect"])
  end
end
