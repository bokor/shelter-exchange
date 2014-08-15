shared_examples_for Geocodeable do

  it "geocode if the address changes" do
    geocodeable = described_class.gen
    expect(geocodeable.lat).to eq(37.769929)
    expect(geocodeable.lng).to eq(-122.446682)
  end

  describe "address_changed?" do

    it "returns true a new record" do
      geocodeable = described_class.new
      expect(geocodeable.address_changed?).to be_true
    end

    it "returns true if street changed" do
      geocodeable = described_class.gen
      geocodeable.street = "testing testing"
      expect(geocodeable.address_changed?).to be_true
    end

    it "returns true if street_2 changed" do
      geocodeable = described_class.gen
      geocodeable.street_2 = "testing testing"
      expect(geocodeable.address_changed?).to be_true
    end

    it "returns true if city changed" do
      geocodeable = described_class.gen
      geocodeable.city = "testing testing"
      expect(geocodeable.address_changed?).to be_true
    end

    it "returns true if state changed" do
      geocodeable = described_class.gen
      geocodeable.state = "testing testing"
      expect(geocodeable.address_changed?).to be_true
    end

    it "returns true if zip_code changed" do
      geocodeable = described_class.gen
      geocodeable.zip_code = "testing testing"
      expect(geocodeable.address_changed?).to be_true
    end
  end

  describe "geocode_address" do
    it "returns a concat address for geocoding" do
      geocodeable = described_class.new(
        :street => "123 Main St.",
        :street_2 => "#101",
        :city => "Redwood City",
        :state => "CA",
        :zip_code => "94063"
      )
      expect(geocodeable.geocode_address).to eq("123 Main St., #101, Redwood City, CA, 94063")
    end
  end
end

