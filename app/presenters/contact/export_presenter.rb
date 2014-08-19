class Contact::ExportPresenter < Presenter

  def initialize(contact)
    @contact = contact
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

  def email
    @contact.email
  end

  def phone
    @contact.phone
  end

  def mobile
    @contact.mobile
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

  def categories
    categories = Contact::ROLES.map do |role|
      "#{role.humanize}" if @contact.send(role)
    end

    categories.compact.join(";")
  end

  def to_csv
    [first_name, last_name, job_title, company_name, email, phone, mobile, street, street_2, city, state, zip_code, categories]
  end

  def self.csv_header
    # Format only handles the outlook csv format for now
    [
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
    ]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end
end

