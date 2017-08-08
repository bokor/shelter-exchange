require 'rails_helper'

describe DataExport::ContactPresenter do

  before do
    @contact = Contact.gen
  end

  describe "#id" do
    it "returns the contact id" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.id).to eq(@contact.id)
    end
  end

  describe "#first_name" do
    it "returns the contact first name" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.first_name).to eq(@contact.first_name)
    end
  end

  describe "#last_name" do
    it "returns the contact last name" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.last_name).to eq(@contact.last_name)
    end
  end

  describe "#job_title" do
    it "returns the contact job title" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.job_title).to eq(@contact.job_title)
    end
  end

  describe "#company_name" do
    it "returns the contact company name" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.company_name).to eq(@contact.company_name)
    end
  end

  describe "#street" do
    it "returns the contact street" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.street).to eq(@contact.street)
    end
  end

  describe "#street_2" do
    it "returns the contact street_2" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.street_2).to eq(@contact.street_2)
    end
  end

  describe "#city" do
    it "returns the contact city" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.city).to eq(@contact.city)
    end
  end

  describe "#state" do
    it "returns the contact state" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.state).to eq(@contact.state)
    end
  end

  describe "#zip_code" do
    it "returns the contact zip code" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.zip_code).to eq(@contact.zip_code)
    end
  end

  describe "#phone" do
    it "returns the contact phone" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.phone).to eq(@contact.phone)
    end
  end

  describe "#mobile" do
    it "returns the contact mobile" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.mobile).to eq(@contact.mobile)
    end
  end

  describe "#email" do
    it "returns the contact email" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.email).to eq(@contact.email)
    end
  end

  describe "#id" do
    it "returns the contact id" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.id).to eq(@contact.id)
    end
  end

  describe "#adopter" do
    it "returns yes when the contact is a adopter" do
      @contact.update_column(:adopter, true)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.adopter).to eq("Yes")
    end

    it "returns no when the task is not a adopter" do
      @contact.update_column(:adopter, false)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.adopter).to eq("No")
    end
  end

  describe "#foster" do
    it "returns yes when the contact is a foster" do
      @contact.update_column(:foster, true)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.foster).to eq("Yes")
    end

    it "returns no when the task is not a foster" do
      @contact.update_column(:foster, false)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.foster).to eq("No")
    end
  end

  describe "#volunteer" do
    it "returns yes when the contact is a volunteer" do
      @contact.update_column(:volunteer, true)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.volunteer).to eq("Yes")
    end

    it "returns no when the task is not a volunteer" do
      @contact.update_column(:volunteer, false)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.volunteer).to eq("No")
    end
  end

  describe "#transporter" do
    it "returns yes when the contact is a transporter" do
      @contact.update_column(:transporter, true)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.transporter).to eq("Yes")
    end

    it "returns no when the task is not a transporter" do
      @contact.update_column(:transporter, false)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.transporter).to eq("No")
    end
  end

  describe "#donor" do
    it "returns yes when the contact is a donor" do
      @contact.update_column(:donor, true)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.donor).to eq("Yes")
    end

    it "returns no when the task is not a donor" do
      @contact.update_column(:donor, false)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.donor).to eq("No")
    end
  end

  describe "#staff" do
    it "returns yes when the contact is a staff" do
      @contact.update_column(:staff, true)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.staff).to eq("Yes")
    end

    it "returns no when the task is not a staff" do
      @contact.update_column(:staff, false)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.staff).to eq("No")
    end
  end

  describe "#veterinarian" do
    it "returns yes when the contact is a veterinarian" do
      @contact.update_column(:veterinarian, true)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.veterinarian).to eq("Yes")
    end

    it "returns no when the task is not a veterinarian" do
      @contact.update_column(:veterinarian, false)
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.veterinarian).to eq("No")
    end
  end

  describe "#create_at" do
    it "returns the contact created at timestamp" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.created_at).to eq(@contact.created_at)
    end
  end

  describe "#updated_at" do
    it "returns the contact updated at timestamp" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.updated_at).to eq(@contact.updated_at)
    end
  end

  describe "#to_csv" do

    it "returns the contact in a csv row format" do
      presenter = DataExport::ContactPresenter.new(@contact)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.first_name,
        presenter.last_name,
        presenter.job_title,
        presenter.company_name,
        presenter.street,
        presenter.street_2,
        presenter.city,
        presenter.state,
        presenter.zip_code,
        presenter.phone,
        presenter.mobile,
        presenter.email,
        presenter.adopter,
        presenter.foster,
        presenter.volunteer,
        presenter.transporter,
        presenter.donor,
        presenter.staff,
        presenter.veterinarian,
        presenter.created_at,
        presenter.updated_at
      ])
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        DataExport::ContactPresenter.csv_header

      ).to eq([
        "Id",
        "First Name",
        "Last Name",
        "Job Title",
        "Company Name",
        "Street",
        "Street 2",
        "City",
        "State",
        "Zip Code",
        "Phone",
        "Mobile",
        "Email",
        "Adopter",
        "Foster",
        "Volunteer",
        "Transporter",
        "Donor",
        "Staff",
        "Veterinarian",
        "Created At",
        "Updated At"
      ])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      contact1 = Contact.gen
      contact2 = Contact.gen
      csv = []

      DataExport::ContactPresenter.as_csv([contact1,contact2], csv)

      expect(csv).to match_array([
        DataExport::ContactPresenter.csv_header,
        DataExport::ContactPresenter.new(contact1).to_csv,
        DataExport::ContactPresenter.new(contact2).to_csv
      ])
    end
  end
end


