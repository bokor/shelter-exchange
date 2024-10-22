shared_examples_for Uploadable do

  describe described_class, "#guid" do

    it "generates a random guid" do
      allow(SecureRandom).to receive(:hex).and_return("abcdef12345")

      uploadable = described_class.gen
      expect(uploadable.guid).to eq("abcdef12345")
    end
  end

  describe described_class, "#timestamp" do

    it "generates a timestamp" do
      Timecop.freeze(Time.now)

      uploadable = described_class.gen
      expect(uploadable.timestamp).to eq(Time.now.to_i)
    end
  end
end

