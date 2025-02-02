class Integration::AdoptAPetPresenter < Presenter

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
    if @animal.other? || @animal.reptile?
      map_to_adopt_a_pet_types
    else
      @animal.animal_type.name
    end
  end

  def breed
    @animal.primary_breed
  end

  def breed2
    @animal.secondary_breed if @animal.dog? || @animal.horse? && @animal.mix_breed?
  end

  def sex
    @animal.sex == "male" ? "M" : "F"
  end

  def description
    s  = @animal.description.blank? ? "No description provided" : @animal.description
    s += "<br>"
    s += "<a href='#{public_save_a_life_url(@animal, :host=> "www.shelterexchange.org")}'>#{@animal.name}, #{@animal.full_breed}</a>"
    s += " has been shared from <a href='http://www.shelterexchange.org'>Shelter Exchange</a>."
    s += "<link rel='canonical' href='#{public_save_a_life_url(@animal, :host=> "www.shelterexchange.org")}' />"

    # Simple format the html
    description = help.auto_link( help.simple_format(s), :all, :target => '_blank')

    # Removing any carriage returns or new lines
    description.gsub(/\n\r?/, "<br>")
  end

  def status
    "Available"
  end

  def purebred
    if @animal.dog? || @animal.rabbit? || @animal.horse?
      @animal.mix_breed? ? "N" : "Y"
    end
  end

  def special_needs
    @animal.special_needs? ? "Y" : "N"
  end

  def size
    unless @animal.size.blank? || @animal.cat? || ["Small Animal"].include?(type)
      if ["Rabbit", "Farm Animal", "Bird", "Horse", "Reptile"].include?(type) && @animal.size == "XL"
        "L"
      else
        @animal.size
      end
    end
  end

  def age
    unless @animal.age.blank?
      if @animal.age == "baby"
        if @animal.dog?
          return "Puppy"
        elsif @animal.cat?
          return "Kitten"
        end
      end
      @animal.age.humanize
    end
  end

  def photos
    photos = []
    unless @animal.photos.blank?
      @animal.photos.each do |photo|
        photos << photo.image.url.gsub(/https:\/\//,"http://") if defined?(photo.image) # replaced https urls with http as there is an issue on adopt-a-pet with secure urls
      end
    end
    (4-@animal.photos.size).times{ photos << nil }
    photos
  end

  def you_tube_url
    unless @animal.video_url.blank?
      you_tube_id = @animal.video_url.match(VIDEO_URL_REGEX)[5] rescue nil
      "http://www.youtube.com/watch?v=#{you_tube_id}" unless you_tube_id.blank?
    end
  end

  def to_csv
    [
      id,
      type,
      breed,
      breed2,
      name,
      sex,
      description,
      status,
      purebred,
      special_needs,
      size,
      age,
      you_tube_url
    ].concat(photos)
  end

  def self.csv_header
    [
      "Id",
      "Animal",
      "Breed",
      "Breed2",
      "Name",
      "Sex",
      "Description",
      "Status",
      "Purebred",
      "SpecialNeeds",
      "Size",
      "Age",
      "YouTubeVideoURL",
      "PhotoURL",
      "PhotoURL2",
      "PhotoURL3",
      "PhotoURL4"
    ]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end

  private

  def map_to_adopt_a_pet_types
    types = {
      AnimalType::TYPES[:other] => {
        "Alpaca" => "Farm Animal",
        "Chinchilla" => "Small Animal",
        "Degu" => "Small Animal",
        "Cow" => "Farm Animal",
        "Ferret" => "Small Animal",
        "Fish" => "Reptile",
        "Frog" => "Reptile",
        "Gerbil" => "Small Animal",
        "Goat" => "Farm Animal",
        "Guinea Pig" => "Small Animal",
        "Hamster" => "Small Animal",
        "Llama" => "Farm Animal",
        "Mouse" => "Small Animal",
        "Pig" => "Farm Animal",
        "Rat" => "Small Animal",
        "Sheep" => "Farm Animal",
        "Sugar Glider" => "Small Animal",
        "Tarantula" => "Reptile"
      },
      AnimalType::TYPES[:reptile] => {
        "Chameleon" => "Reptile",
        "Gecko" => "Reptile",
        "Iguana" => "Reptile",
        "Lizard" => "Reptile",
        "Snake" => "Reptile",
        "Tortoise" => "Reptile",
        "Turtle" => "Reptile"
      }
    }
   types[@animal.animal_type_id][@animal.primary_breed]
  end
end

