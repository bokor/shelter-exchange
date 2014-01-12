require "spec_helper"

describe ShelterExchange::Jobs::FacebookLinterJob, ".perform" do

  it "does nothing when id is blank" do
    ShelterExchange::Jobs::FacebookLinterJob.new().perform
    Net::HTTP.should_not_receive(:post_form)
  end

  it "posts data to the facebook scrape endpoint" do
    uri = URI("https://graph.facebook.com")
    params = { :id => "http://www.shelterexchange.org/save_a_life/12345", :scrape => true }

    response = nil
    VCR.use_cassette('facebook_linter_job') do
      Net::HTTP.should_receive(:post_form).with(uri, params).and_call_original
      response = ShelterExchange::Jobs::FacebookLinterJob.new(12345).perform
    end

    response.code.should == "200"
    MultiJson.load(response.body)["url"].should == "http://www.shelterexchange.org/save_a_life/12345"
  end
end

