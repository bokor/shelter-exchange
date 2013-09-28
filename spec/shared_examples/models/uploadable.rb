shared_examples_for Uploadable do

  describe described_class, "#guid" do

    it "generates a random guid" do
      SecureRandom.stub(:hex).and_return("abcdef12345")

      uploadable = described_class.gen
      uploadable.guid.should == "abcdef12345"
    end
  end

  describe described_class, "#timestamp" do

    it "generates a timestamp" do
      now = Time.now
      Time.stub!(:now).and_return(now)

      uploadable = described_class.gen
      uploadable.timestamp.should == now.to_i
    end
  end
end
