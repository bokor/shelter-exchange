require 'spec_helper'

describe Contact::ExportPresenter do

  before do
    @contact = Contact.gen
  end

  describe "#first_name" do
    it "returns the contact first name" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.first_name).to eq(@contact.first_name)
    end
  end

  describe "#last_name" do
    it "returns the contact last name" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.last_name).to eq(@contact.last_name)
    end
  end

  describe "#job_title" do
    it "returns the contact job_title" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.job_title).to eq(@contact.job_title)
    end
  end

  describe "#company_name" do
    it "returns the contact company_name" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.company_name).to eq(@contact.company_name)
    end
  end

  describe "#email" do
    it "returns the contact email" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.email).to eq(@contact.email)
    end
  end

  describe "#phone" do
    it "returns the contact phone" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.phone).to eq(@contact.phone)
    end
  end

  describe "#mobile" do
    it "returns the contact mobile" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.mobile).to eq(@contact.mobile)
    end
  end

  describe "#street" do
    it "returns the contact street" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.street).to eq(@contact.street)
    end
  end

  describe "#street_2" do
    it "returns the contact street_2" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.street_2).to eq(@contact.street_2)
    end
  end

  describe "#city" do
    it "returns the contact city" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.city).to eq(@contact.city)
    end
  end

  describe "#zip_code" do
    it "returns the contact zip_code" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.zip_code).to eq(@contact.zip_code)
    end
  end

  describe "#categories" do
    it "returns the contact categories" do
      @contact.update_attributes({ :adopter => true, :staff => true })

      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.categories).to eq("Adopter;Staff")
    end
  end

  describe "#to_csv" do
    it "returns the animal in a csv row format" do
      presenter = Contact::ExportPresenter.new(@contact)
      expect(presenter.to_csv).to eq([
        presenter.first_name,
        presenter.last_name,
        presenter.job_title,
        presenter.company_name,
        presenter.email,
        presenter.phone,
        presenter.mobile,
        presenter.street,
        presenter.street_2,
        presenter.city,
        presenter.state,
        presenter.zip_code,
        presenter.categories
      ])
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        Contact::ExportPresenter.csv_header
      ).to eq([
        "First Name",
        "Last Name",
        "Job Title",
        "Company Name",
        "E-mail Address",
        "Home Phone",
        "Mobile Phone",
        "Home Street",
        "Home Street 2",
        "Home City",
        "Home State",
        "Home Postal Code",
        "Categories"
      ])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      contact1 = Contact.gen
      contact2 = Contact.gen
      csv = []

      Contact::ExportPresenter.as_csv([contact1, contact2], csv)

      expect(csv).to match_array([
        Contact::ExportPresenter.csv_header,
        Contact::ExportPresenter.new(contact1).to_csv,
        Contact::ExportPresenter.new(contact2).to_csv
      ])
    end
  end
end


