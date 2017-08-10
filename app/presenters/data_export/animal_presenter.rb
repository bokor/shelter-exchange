class DataExport::AnimalPresenter < Presenter

  def initialize(animal)
    @animal = animal
  end

  def id
    @animal.id
  end

  def microchip
    @animal.microchip
  end

  def name
    @animal.name
  end

  def status
    @animal.animal_status.name
  end

  def type
    @animal.animal_type.name
  end

  def primary_breed
    @animal.primary_breed
  end

  def secondary_breed
    @animal.secondary_breed
  end

  def mixed_breed
    @animal.mix_breed? ? "Yes" : "No"
  end

  def sterilized
    @animal.sterilized? ? "Yes" : "No"
  end

  def sex
    @animal.sex.humanize
  end

  def date_of_birth
    @animal.date_of_birth
  end

  def color
    @animal.color
  end

  def weight
    @animal.weight
  end

  def size
    Animal::SIZES[@animal.size.to_sym] if @animal.size
  end

  def age
    @animal.age.humanize
  end

  def special_needs
    @animal.special_needs? ? "Yes" : "No"
  end

  def special_needs_description
    @animal.special_needs
  end

  def status_date
    @animal.status_change_date
  end

  def arrival_date
    @animal.arrival_date
  end

  def hold_time
    @animal.hold_time
  end

  def euthanasia_date
    @animal.euthanasia_date
  end

  def accommodation_id
    @animal.accommodation_id
  end

  def video_url
    @animal.video_url
  end

  def description
    @animal.description
  end

  def created_at
    @animal.created_at
  end

  def updated_at
    @animal.updated_at
  end

  def to_csv
    [
      id,
      microchip,
      name,
      status,
      type,
      primary_breed,
      secondary_breed,
      mixed_breed,
      sterilized,
      sex,
      date_of_birth,
      color,
      weight,
      size,
      age,
      special_needs,
      special_needs_description,
      status_date,
      arrival_date,
      hold_time,
      euthanasia_date,
      accommodation_id,
      video_url,
      description,
      created_at,
      updated_at
    ]
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.csv_header
    [
      "Id",
      "Microchip",
      "Name",
      "Status",
      "Type",
      "Primary Breed",
      "Secondary Breed",
      "Mixed Breed",
      "Sterilized",
      "Sex",
      "Date of Birth",
      "Color",
      "Weight",
      "Size",
      "Age",
      "Special Needs",
      "Special Needs Description",
      "Status Date",
      "Arrival Date",
      "Hold Time",
      "Euthanasia Date",
      "Accommodation Id",
      "Video URL",
      "Description",
      "Created At",
      "Updated At"
    ]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end
end

