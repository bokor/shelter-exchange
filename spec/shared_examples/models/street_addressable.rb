shared_examples_for StreetAddressable do

  describe "validates presence of a full address" do

    it "validates street blank" do
      addressable = described_class.new :street => nil
      expect(addressable).to have(1).error_on(:address)
      expect(addressable.errors[:address]).to include("Street, City, State and Zip code are all required")
    end

    it "validates city blank" do
      addressable = described_class.new :city => nil
      expect(addressable).to have(1).error_on(:address)
      expect(addressable.errors[:address]).to include("Street, City, State and Zip code are all required")
    end

    it "validates state blank" do
      addressable = described_class.new :state => nil
      expect(addressable).to have(1).error_on(:address)
      expect(addressable.errors[:address]).to include("Street, City, State and Zip code are all required")
    end

    it "validates zip code blank" do
      addressable = described_class.new :zip_code => nil
      expect(addressable).to have(1).error_on(:address)
      expect(addressable.errors[:address]).to include("Street, City, State and Zip code are all required")
    end
  end
end

