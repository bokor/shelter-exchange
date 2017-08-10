class DataExport::ContactPresenter < Presenter

  def initialize(contact)
    @contact = contact
  end

  def id
    @contact.id
  end

  def first_name
    @contact.first_name
  end

  def last_name
    @contact.last_name
  end

  def job_title
    @contact.job_title
  end

  def company_name
    @contact.company_name
  end

  def street
    @contact.street
  end

  def street_2
    @contact.street_2
  end

  def city
    @contact.city
  end

  def state
    @contact.state
  end

  def zip_code
    @contact.zip_code
  end

  def phone
    @contact.phone
  end

  def mobile
    @contact.mobile
  end

  def email
    @contact.email
  end

  def adopter
    @contact.adopter ? "Yes" : "No"
  end

  def foster
    @contact.foster ? "Yes" : "No"
  end

  def volunteer
    @contact.volunteer ? "Yes" : "No"
  end

  def transporter
    @contact.transporter ? "Yes" : "No"
  end

  def donor
    @contact.donor ? "Yes" : "No"
  end

  def staff
    @contact.staff ? "Yes" : "No"
  end

  def veterinarian
    @contact.veterinarian ? "Yes" : "No"
  end

  def created_at
    @contact.created_at
  end

  def updated_at
    @contact.updated_at
  end

  def to_csv
    [
      id,
      first_name,
      last_name,
      job_title,
      company_name,
      street,
      street_2,
      city,
      state,
      zip_code,
      phone,
      mobile,
      email,
      adopter,
      foster,
      volunteer,
      transporter,
      donor,
      staff,
      veterinarian,
      created_at,
      updated_at
    ]
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.csv_header
    [
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
    ]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end
end


