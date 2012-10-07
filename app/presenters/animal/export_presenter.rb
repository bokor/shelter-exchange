class Animal::ExportPresenter < Presenter

  def initialize(animal)
    @animal = animal
  end
  
  def id
    @animal.id
  end
  
  def name
    @animal.name
  end
  
  def type
    @animal.animal_type.name
  end
  
  def status
    @animal.animal_status.name
  end
  
  def mixed_breed
    @animal.mix_breed? ? "Y" : "N"
  end
  
  def primary_breed
    @animal.primary_breed
  end
  
  def secondary_breed
    @animal.secondary_breed if @animal.mix_breed?
  end
  
  def microchip
    @animal.microchip
  end
  
  def sterilized
    @animal.sterilized? ? "Y" : "N"
  end
  
  def sex
    @animal.sex.humanize
  end
  
  def size
    Animal::SIZES[@animal.size.to_sym] || "N/A"
  end
  
  def color
    @animal.color
  end
  
  def weight
    @animal.weight
  end
  
  def age
    @animal.age.humanize unless @animal.age.blank?
  end
  
  def arrival_date
    @animal.arrival_date
  end
  
  def special_needs
    @animal.special_needs? ? "Y" : "N"
  end
  
  def special_needs_description
    @animal.special_needs
  end

  def special_needs
    @animal.special_needs?  ? "Y" : "N"
  end 
  
  def special_needs_description
    @animal.special_needs
  end
  
  def description
    @animal.description.blank? ? "No description provided" : help.auto_link( help.simple_format(@animal.description), :all, :target => "_blank")
  end
  
  def photos
    photos = []
    unless @animal.photos.blank?
      @animal.photos.each do |photo|
        photos << photo.image.url if defined?(photo.image)
      end
    end
    (4-@animal.photos.size).times{ photos << nil}
    photos
  end
  
  def video_url
    unless @animal.video_url.blank?
      you_tube_id = @animal.video_url.match(VIDEO_URL_REGEX)[5]
      you_tube_id.blank? ? @animal.video_url : "http://www.youtube.com/watch?v=#{you_tube_id}" 
    end
  end 

  def to_csv
    [id, name, type, status, mixed_breed, primary_breed, secondary_breed, microchip, sterilized, sex.humanize, size, color, weight, age, arrival_date, special_needs, special_needs_description, description, photos, video_url].flatten
  end
  
  def self.csv_header
    ["Id", "Name", "Type", "Status", "Mixed Breed", "Primary Breed", "Secondary Breed", "Microchip", "Sterilized", "Sex", "Size", "Color", "Weight", "Age", "Arrival Date", "Has Special Needs", "Special Needs Description", "Description", "Photo1", "Photo2", "Photo3", "Photo4", "Video"]
  end

end