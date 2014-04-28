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

describe DateHelper, "#time_diff_in_natural_language" do

  it "returns humanized time in years and months" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2011, 12, 15)

    expect(
      helper.time_diff_in_natural_language(from_time, to_time)
    ).to eq("2 years and 2 months")
  end

  it "returns humanized time in multiple months" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2013, 12, 15)

    expect(
      helper.time_diff_in_natural_language(from_time, to_time)
    ).to eq("2 months")
  end

  it "returns humanized time in 1 month" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2014, 01, 14)

    expect(
      helper.time_diff_in_natural_language(from_time, to_time)
    ).to eq("1 month")
  end

  it "returns humanized time in multiple weeks" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2014, 01, 28)

    expect(
      helper.time_diff_in_natural_language(from_time, to_time)
    ).to eq("2 weeks")
  end

  it "returns humanized time in 1 week" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2014, 02, 07)

    expect(
      helper.time_diff_in_natural_language(from_time, to_time)
    ).to eq("1 week")
  end

  it "returns humanized time less than 1 week" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2014, 02, 10)
    expect(
      helper.time_diff_in_natural_language(from_time, to_time)
    ).to eq("Less than 1 week")
  end
end

describe DateHelper, "#months_between" do

  it "returns 0 when no months between two dates" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2014, 02, 07)

    expect(
      helper.months_between(from_time, to_time)
    ).to eq(0)
  end

  it "returns months between two dates when exactly 1 month" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2014, 01, 14)

    expect(
      helper.months_between(from_time, to_time)
    ).to eq(1)
  end

  it "returns months between two dates" do
    from_time = Date.new(2014, 02, 14)
    to_time = Date.new(2013, 11, 01)

    expect(
      helper.months_between(from_time, to_time)
    ).to eq(3)
  end
end

