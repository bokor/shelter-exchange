shared_examples_for StreetAddressable do
  describe Parent, "StreetAddressable" do

    describe "validates presence of a full address" do

      it "validates street blank" do
        parent = Parent.new :street => nil
        parent.should have(1).error_on(:address)
        parent.errors[:address].should == ["Street, City, State and Zip code are all required"]
      end

      it "validates city blank" do
        parent = Parent.new :city => nil
        parent.should have(1).error_on(:address)
        parent.errors[:address].should == ["Street, City, State and Zip code are all required"]
      end

      it "validates state blank" do
        parent = Parent.new :state => nil
        parent.should have(1).error_on(:address)
        parent.errors[:address].should == ["Street, City, State and Zip code are all required"]
      end

      it "validates zip code blank" do
        parent = Parent.new :zip_code => nil
        parent.should have(1).error_on(:address)
        parent.errors[:address].should == ["Street, City, State and Zip code are all required"]
      end
    end

    describe "address_changed?" do

      it "returns true a new record" do
        parent = Parent.new
        parent.address_changed?.should == true
      end

      it "returns true if street changed" do
        parent = Parent.gen
        parent.street = "testing testing"
        parent.address_changed?.should == true
      end

      it "returns true if street_2 changed" do
        parent = Parent.gen
        parent.street_2 = "testing testing"
        parent.address_changed?.should == true
      end

      it "returns true if city changed" do
        parent = Parent.gen
        parent.city = "testing testing"
        parent.address_changed?.should == true
      end

      it "returns true if state changed" do
        parent = Parent.gen
        parent.state = "testing testing"
        parent.address_changed?.should == true
      end

      it "returns true if zip_code changed" do
        parent = Parent.gen
        parent.zip_code = "testing testing"
        parent.address_changed?.should == true
      end
    end

    describe "geocode_address" do
      it "returns a concat address for geocoding" do
        parent = Parent.new(
          :street => "123 Main St.",
          :street_2 => "#101",
          :city => "Redwood City",
          :state => "CA",
          :zip_code => "94063"
        )
        parent.geocode_address.should == "123 Main St., #101, Redwood City, CA, 94063"
      end
    end
  end
end
