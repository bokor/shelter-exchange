shared_examples_for StreetAddressable do

  describe "validates presence of a full address" do

    it "validates street blank" do
      addressable = described_class.new :street => nil
      addressable.should have(1).error_on(:address)
      addressable.errors[:address].should == ["Street, City, State and Zip code are all required"]
    end

    it "validates city blank" do
      addressable = described_class.new :city => nil
      addressable.should have(1).error_on(:address)
      addressable.errors[:address].should == ["Street, City, State and Zip code are all required"]
    end

    it "validates state blank" do
      addressable = described_class.new :state => nil
      addressable.should have(1).error_on(:address)
      addressable.errors[:address].should == ["Street, City, State and Zip code are all required"]
    end

    it "validates zip code blank" do
      addressable = described_class.new :zip_code => nil
      addressable.should have(1).error_on(:address)
      addressable.errors[:address].should == ["Street, City, State and Zip code are all required"]
    end
  end

  describe "address_changed?" do

    it "returns true a new record" do
      addressable = described_class.new
      addressable.address_changed?.should == true
    end

    it "returns true if street changed" do
      addressable = described_class.gen
      addressable.street = "testing testing"
      addressable.address_changed?.should == true
    end

    it "returns true if street_2 changed" do
      addressable = described_class.gen
      addressable.street_2 = "testing testing"
      addressable.address_changed?.should == true
    end

    it "returns true if city changed" do
      addressable = described_class.gen
      addressable.city = "testing testing"
      addressable.address_changed?.should == true
    end

    it "returns true if state changed" do
      addressable = described_class.gen
      addressable.state = "testing testing"
      addressable.address_changed?.should == true
    end

    it "returns true if zip_code changed" do
      addressable = described_class.gen
      addressable.zip_code = "testing testing"
      addressable.address_changed?.should == true
    end
  end

  describe "geocode_address" do
    it "returns a concat address for geocoding" do
      addressable = described_class.new(
        :street => "123 Main St.",
        :street_2 => "#101",
        :city => "Redwood City",
        :state => "CA",
        :zip_code => "94063"
      )
      addressable.geocode_address.should == "123 Main St., #101, Redwood City, CA, 94063"
    end
  end
end
