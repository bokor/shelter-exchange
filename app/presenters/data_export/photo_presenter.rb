class DataExport::PhotoPresenter < Presenter

  def initialize(photo)
    @photo = photo
  end

  def id
    @photo.id
  end

  def image
    "photos/#{@photo.original_name}" rescue nil
  end

  def animal_id
    @photo.attachable_id if @photo.attachable_id and @photo.attachable_type == "Animal"
  end

  def created_at
    @photo.created_at
  end

  def updated_at
    @photo.updated_at
  end

  def to_csv
    [id, image, animal_id, created_at, updated_at]
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.csv_header
    ["Id", "Image", "Animal Id", "Created At", "Updated At"]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end
end

