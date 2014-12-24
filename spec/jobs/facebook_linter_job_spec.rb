require "spec_helper"

describe FacebookLinterJob, ".perform" do

  it "does nothing when id is blank" do
    FacebookLinterJob.new().perform
    expect(Net::HTTP).not_to receive(:post_form)
  end

  it "posts data to the facebook scrape endpoint" do
    stub_request(:post, 'https://graph.facebook.com').with(
      :body => { 'id' => 'http://www.shelterexchange.org/save_a_life/12345', 'scrape' => 'true' }
    ).to_return(:status => 200, :body => "", :headers => {})

    response = FacebookLinterJob.new(12345).perform
    expect(response.code).to eq("200")
  end
end

