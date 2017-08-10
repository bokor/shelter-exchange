class DataExport::StatusHistoryPresenter < Presenter

  def initialize(status_history)
    @status_history = status_history
  end

  def id
    @status_history.id
  end

  def status
    @status_history.animal_status.name
  end

  def status_date
    @status_history.status_date
  end

  def reason
    @status_history.reason
  end

  def animal_id
    @status_history.animal_id
  end

  def contact_id
    @status_history.contact_id
  end

  def created_at
    @status_history.created_at
  end

  def updated_at
    @status_history.updated_at
  end

  def to_csv
    [
      id,
      status,
      status_date,
      reason,
      animal_id,
      contact_id,
      created_at,
      updated_at
    ]
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.csv_header
    ["Id", "Status", "Status Date", "Reason", "Animal Id", "Contact Id", "Created At", "Updated At"]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end
end

