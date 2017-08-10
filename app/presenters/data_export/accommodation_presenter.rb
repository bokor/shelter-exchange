class DataExport::AccommodationPresenter < Presenter

  def initialize(acccommodation)
    @acccommodation = acccommodation
  end

  def id
    @acccommodation.id
  end

  def name
    @acccommodation.name
  end

  def max_capacity
    @acccommodation.max_capacity
  end

  def animal_type
    @acccommodation.animal_type.name
  end

  def location_name
    @acccommodation.location ? @acccommodation.location.name : "None"
  end

  def created_at
    @acccommodation.created_at
  end

  def updated_at
    @acccommodation.updated_at
  end

  def to_csv
    [id, name, max_capacity, animal_type, location_name, created_at, updated_at]
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.csv_header
    ["Id", "Name", "Max Capacity", "Animal Type", "Location Name", "Created At", "Updated At"]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end
end


