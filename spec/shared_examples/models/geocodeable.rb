shared_examples_for Geocodeable do

  it "geocode if the address changes" do
    geocodeable = described_class.gen
    expect(geocodeable.lat).to eq(37.769929)
    expect(geocodeable.lng).to eq(-122.446682)
  end
end

