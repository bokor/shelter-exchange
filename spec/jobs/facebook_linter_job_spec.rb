require "spec_helper"

describe FacebookLinterJob, ".perform" do

  it "does nothing when id is blank" do
    FacebookLinterJob.new().perform
    expect(Net::HTTP).not_to receive(:post_form)
  end

  it "posts data to the facebook scrape endpoint" do
    uri = URI("https://graph.facebook.com")
    params = { :id => "http://www.shelterexchange.org/save_a_life/12345", :scrape => true }

    response = nil
    VCR.use_cassette('facebook_linter_job') do
      expect(Net::HTTP).to receive(:post_form).with(uri, params).and_call_original
      response = FacebookLinterJob.new(12345).perform
    end

    expect(response.code).to eq("200")
    expect(MultiJson.load(response.body)["url"]).to eq("http://www.shelterexchange.org/save_a_life/12345")
  end
end

