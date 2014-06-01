require "spec_helper"

describe DateHelper, "#date_attribute_for" do

  it "returns nil when there is no value" do
    expect(
      helper.date_attribute_for(Animal.gen, :date_of_birth, nil)
    ).to be_nil
  end

  it "returns the day value from the date_of_birth_day value" do
    animal = Animal.gen :date_of_birth_month => "02", :date_of_birth_day => "14", :date_of_birth_year => "2014"

    expect(
      helper.date_attribute_for(animal, :date_of_birth, :day)
    ).to eq("14")
  end

  it "returns the day value from the date_of_birth value when date_of_birth_day doesn't exist" do
    Animal.gen :date_of_birth_month => "02", :date_of_birth_day => "14", :date_of_birth_year => "2014"
    animal = Animal.last

    expect(
      helper.date_attribute_for(animal, :date_of_birth, :day)
    ).to eq("14")
  end
end

describe DateHelper, "#format_date_for" do

  before do
    @date = Date.new(2014, 02, 14)
  end

  it "returns nil when there is no date present" do
    expect(
      helper.format_date_for("")
    ).to be_nil
  end

  it "returns a short_no_year date value" do
    expect(
      helper.format_date_for(@date, :short_no_year)
    ).to eq("Feb 14")
  end

  it "returns a short date value" do
    expect(
      helper.format_date_for(@date, :short)
    ).to eq("Feb 14, 14")
  end

  it "returns a short_full_year date value" do
    expect(
      helper.format_date_for(@date, :short_full_year)
    ).to eq("Feb 14, 2014")
  end

  it "returns a long date value" do
    expect(
      helper.format_date_for(@date, :long)
    ).to eq("February 14, 2014")
  end

  it "returns a long_day_of_week date value" do
    expect(
      helper.format_date_for(@date, :long_day_of_week)
    ).to eq("Fri February 14, 2014")
  end

  it "returns a month date value" do
    expect(
      helper.format_date_for(@date, :month)
    ).to eq("02")
  end

  it "returns a day date value" do
    expect(
      helper.format_date_for(@date, :day)
    ).to eq("14")
  end

  it "returns a year date value" do
    expect(
      helper.format_date_for(@date, :year)
    ).to eq("2014")
  end

  it "returns a default date value" do
    expect(
      helper.format_date_for(@date, :default)
    ).to eq("02/14/2014")
  end
end
