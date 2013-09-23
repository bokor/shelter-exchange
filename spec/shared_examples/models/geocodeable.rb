shared_examples_for Geocodeable do

  it "geocode if the address changes" do
    geocodeable = described_class.gen
    geocodeable.lat.should == 37.769929
    geocodeable.lng.should == -122.446682
  end
end

