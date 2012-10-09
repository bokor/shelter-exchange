class Integration::PetfinderPresenter < Presenter

  # PETFINDER_TYPES = { 
  #                       "Other" => { 
  #                         "Alpaca" => "Farm Animal", "Chinchilla" => "Small Animal", "Cow" => "Farm Animal",
  #                         "Ferret" => "Small Animal", "Fish" => "Reptile", "Frog" => "Reptile", "Gerbil" => "Small Animal", "Goat" => "Farm Animal",
  #                         "Guinea Pig" => "Small Animal","Hamster" => "Small Animal","Llama" => "Farm Animal","Mouse" => "Small Animal",
  #                         "Pig" => "Farm Animal","Rat" => "Small Animal","Sheep" => "Farm Animal","Tarantula" => "Reptile" },
  #                       "Reptile" => {
  #                         "Chameleon" => "Reptile","Gecko" => "Reptile","Iguana" => "Reptile","Lizard" => "Reptile",
  #                         "Snake" => "Reptile","Tortoise" => "Reptile","Turtle" => "Reptile" }
  #                     }

  def initialize(animal)
    @animal = animal
  end
  
  def id
    @animal.id
  end

  def name
    @animal.name
  end

  def breed
    @animal.primary_breed
  end
  
  def breed2
    @animal.secondary_breed if @animal.mix_breed?
  end

  def sex
    @animal.sex == "male" ? "M" : "F"
  end

  def size
    @animal.size unless @animal.size.blank?
  end  

  def age
    @animal.age.humanize unless @animal.age.blank?
  end

  def description 
    s = @animal.description.blank? ? "No description provided" : help.auto_link( help.simple_format(@animal.description), :all, :target => "_blank")
    s << "<br>"
    s << "<a href='#{public_save_a_life_url(@animal, :host=> "www.shelterexchange.org")}'>#{@animal.name}, #{@animal.full_breed}</a> "
    s << "has been shared from <a href='http://www.shelterexchange.org'>Shelter Exchange</a>."
    s << "<link rel='canonical' href='#{public_save_a_life_url(@animal, :host=> "www.shelterexchange.org")}' />"
    s
  end

  # TO DO ::
  def type
    @animal.other? || @animal.reptile? ? ADOPT_A_PET_TYPES[@animal.animal_type.name][@animal.primary_breed] : @animal.animal_type.name
  end
  
  def status
    return 'A' if @animal.available_for_adoption?
    return 'P' if @animal.adoption_pending?
  end

  def altered
    1 if @animal.sterilized?
  end
  
  def mix
    1 if @animal.mix_breed?
  end
  
  def special_needs
    1 if @animal.special_needs?
  end 
  
  # TO DO ::
  def photos
    photos = []
    unless @animal.photos.blank?
      @animal.photos.limit(3).each_with_index do |photo, index|
        photos << "#{id}-#{index+1}#{File.extname(photo.image.url)}" # 1234-1.jpg is the format
      end
    end
    (3-@animal.photos.size).times{ photos << nil }
    photos
  end

  def to_csv
    [
      id, 
      '', 
      name, 
      breed, 
      breed2, 
      sex, 
      size, 
      age, 
      description, 
      type, 
      status, 
      '', 
      altered, 
      '', '', '', '', '', 
      special_needs, 
      mix, 
      photos
    ].flatten
  end
  
  def self.csv_header
    [
      "ID",
      "Internal",
      "AnimalName",
      "PrimaryBreed",
      "SecondaryBreed",
      "Sex",
      "Size",
      "Age",
      "Desc",
      "Type",
      "Status",
      "Shots",
      "Altered",
      "NoDogs","NoCats","NoKids","Housetrained","Declawed",
      "specialNeeds",
      "Mix",
      "photo1",
      "photo2",
      "photo3"
    ]
  end

end