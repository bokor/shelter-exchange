require "spec_helper"

class DateFormatValidatable
  include ActiveModel::Validations
  attr_accessor :random_date, :random_date_year, :random_date_month, :random_date_day
  attr_accessor :date_of_birth, :date_of_birth_year, :date_of_birth_month, :date_of_birth_day
  validates :date_of_birth, :date_format => true
  validates :random_date, :date_format => true
end

describe DateFormatValidator do

  subject { DateFormatValidatable.new }

  context "when any date" do

    it "valid when blank record" do
      subject.random_date_year = ""
      subject.random_date_month = ""
      subject.random_date_day = ""

      expect(subject).to be_valid
    end

    it "valid when correct format" do
      subject.random_date_year = "2014"
      subject.random_date_month = "05"
      subject.random_date_day = "12"

      expect(subject).to be_valid
    end

    it "invalid when day is missing" do
      subject.random_date_year = "2014"
      subject.random_date_month = "05"
      subject.random_date_day = ""

      expect(subject).not_to be_valid
      expect(subject).to have(1).error_on(:random_date)
      expect(subject.errors[:random_date]).to match_array(["is an invalid date format"])
    end

    it "invalid when month is missing" do
      subject.random_date_year = "2014"
      subject.random_date_month = ""
      subject.random_date_day = "12"

      expect(subject).not_to be_valid
      expect(subject).to have(1).error_on(:random_date)
      expect(subject.errors[:random_date]).to match_array(["is an invalid date format"])
    end

    it "invalid when year is missing" do
      subject.random_date_year = ""
      subject.random_date_month = "05"
      subject.random_date_day = "12"

      expect(subject).not_to be_valid
      expect(subject).to have(1).error_on(:random_date)
      expect(subject.errors[:random_date]).to match_array(["is an invalid date format"])
    end

    it "invalid when year is less than 4 digits" do
      subject.random_date_year = "14"
      subject.random_date_month = "05"
      subject.random_date_day = "12"

      expect(subject).not_to be_valid
      expect(subject).to have(1).error_on(:random_date)
      expect(subject.errors[:random_date]).to match_array(["is an invalid date format"])
    end
  end

  context "when field is date of birth" do

    it "valid when correct format" do
      subject.date_of_birth_year = Date.today.year - 1
      subject.date_of_birth_month = Date.today.month
      subject.date_of_birth_day = Date.today.day

      expect(subject).to be_valid
    end

    it "invalid when the date is greater than today" do
      subject.date_of_birth_year = Date.today.year + 1
      subject.date_of_birth_month = "05"
      subject.date_of_birth_day = "12"

      expect(subject).not_to be_valid
      expect(subject).to have(1).error_on(:date_of_birth)
      expect(subject.errors[:date_of_birth]).to match_array(["has to be before today's date"])
    end
  end
end
