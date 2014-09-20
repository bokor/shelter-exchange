class Integration::PetfinderPresenter < Presenter

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
    map_to_petfinder_breeds(@animal.primary_breed)
  end

  def breed2
    map_to_petfinder_breeds(@animal.secondary_breed) if @animal.mix_breed?
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
    s = @animal.description.blank? ? "No description provided" : @animal.description
    s += "&#13;&#13;"
    s += "#{@animal.name}, #{@animal.full_breed} has been shared from Shelter Exchange - http://www.shelterexchange.org."

    # Simple format the html
    description = help.simple_format(s)

    # Removing any carriage returns or new lines
    description.gsub(/\n\r?/, "<br>")
  end

  def type
    @animal.other? || @animal.reptile? ? map_to_petfinder_types : @animal.animal_type.name
  end

  def status
    return "A" if @animal.available_for_adoption?
    return "P" if @animal.adoption_pending?
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

  # TODO ::
  def photos
    photos = []
    unless @animal.photos.blank?
      @animal.photos.take(3).each_with_index do |photo, index|
        photos << "#{id}-#{index+1}#{File.extname(photo.image.url)}" # 1234-1.jpg is the format
      end
    end
    (3-@animal.photos.size).times{ photos << nil }
    photos
  end

  def to_csv
    [
      id,
      "",
      name,
      breed,
      breed2,
      sex,
      size,
      age,
      description,
      type,
      status,
      "",
      altered,
      "", "", "", "", "",
      special_needs,
      mix
    ].concat(photos)
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

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end

  private

  def map_to_petfinder_types
    local_types = {
      "Chameleon"   => "Scales, Fins & Other",
      "Gecko"       => "Scales, Fins & Other",
      "Iguana"      => "Scales, Fins & Other",
      "Lizard"      => "Scales, Fins & Other",
      "Snake"       => "Scales, Fins & Other",
      "Tortoise"    => "Scales, Fins & Other",
      "Turtle"      => "Scales, Fins & Other",
      "Alpaca"      => "Barnyard",
      "Cow"         => "Barnyard",
      "Goat"        => "Barnyard",
      "Llama"       => "Barnyard",
      "Pig"         => "Barnyard",
      "Sheep"       => "Barnyard",
      "Chinchilla"  => "Small & Furry",
      "Ferret"      => "Small & Furry",
      "Gerbil"      => "Small & Furry",
      "Guinea Pig"  => "Small & Furry",
      "Hamster"     => "Small & Furry",
      "Mouse"       => "Small & Furry",
      "Rat"         => "Small & Furry",
      "Tarantula"   => "Small & Furry",
      "Fish"        => "Scales, Fins & Other",
      "Frog"        => "Scales, Fins & Other"
    }
    local_types[@animal.primary_breed]
  end

  def map_to_petfinder_breeds(breed)
    local_breeds = {
      # Dog
      "American Foxhound"                   => "Foxhound",
      "American Pit Bull Terrier"           => "Pit Bull Terrier",
      "Australian Cattle Dog"               => "Australian Cattle Dog (Blue Heeler)",
      "Belgian Shepherd - Laekenois"        => "Belgian Shepherd Laekenois",
      "Belgian Shepherd - Malinois"         => "Belgian Shepherd Malinois",
      "Belgian Shepherd - Sheepdog"         => "Belgian Shepherd Dog Sheepdog",
      "Belgian Shepherd - Tervuren"         => "Belgian Shepherd Tervuren",
      "Blue Heeler"                         => "Australian Cattle Dog (Blue Heeler)",
      "Bouvier des Ardennes"                => "Bouvier des Flandres",
      "Bouvier des Flandres"                => "Bouvier des Flandres",
      "Canadian Eskimo Dog"                 => "Eskimo Dog",
      "Cane Corso"                          => "Cane Corso Mastiff",
      "Catahoula Cur"                       => "Catahoula Leopard Dog",
      "Caucasian Shepherd Dog"              => "Caucasian Sheepdog (Caucasian Ovtcharka)",
      "Chinese Crested"                     => "Chinese Crested Dog",
      "English Foxhound"                    => "Foxhound",
      "English Mastiff"                     => "Mastiff",
      "Entlebucher Mountain Dog"            => "Entlebucher",
      "Finnish Hound"                       => "Hound",
      "French Spaniel"                      => "Spaniel",
      "German Longhaired Pointer"           => "Pointer",
      "German Spaniel"                      => "Spaniel",
      "Halden Hound"                        => "Hound",
      "Icelandic Sheepdog"                  => "Norwegian Buhund",
      "King Charles Spaniel"                => "Cavalier King Charles Spaniel",
      "Korean Jindo Dog"                    => "Jindo",
      "Labrador Husky"                      => "Husky",
      "Longhaired Whippet"                  => "Whippet",
      "Mexican Hairless Dog"                => "Xoloitzcuintle (Mexican Hairless)",
      "Miniature Australian Shepherd"       => "Australian Shepherd",
      "Miniature Fox Terrier"               => "Fox Terrier",
      "Miniature Schnauzer"                 => "Schnauzer",
      "Miniature Siberian Husky"            => "Siberian Husky",
      "Newfoundland"                        => "Newfoundland Dog",
      "Parson Russell Terrier"              => "Jack Russell Terrier",
      "Pembroke Welsh Corgi"                => "Welsh Corgi",
      "Picardy Shepherd"                    => "Shepherd",
      "Portuguese Pointer"                  => "Portuguese Water Dog",
      "Portuguese Water Dog"                => "Portuguese Water Dog",
      "Pyrenean Mastiff"                    => "Mastiff",
      "Pyrenean Shepherd"                   => "Shepherd",
      "Russian Spaniel"                     => "Spaniel",
      "Russian Toy"                         => "Terrier",
      "Saint Bernard"                       => "Saint Bernard St. Bernard",
      "Schiller Hound"                      => "Hound",
      "Scottish Terrier"                    => "Scottish Terrier Scottie",
      "Sheltie, Shetland Sheepdog"          => "Shetland Sheepdog Sheltie",
      "Shiloh Shepherd Dog"                 => "German Shepherd Dog",
      "Spanish Mastiff"                     => "Mastiff",
      "Spanish Water Dog"                   => "Portuguese Water Dog",
      "Westie, West Highland White Terrier" => "West Highland White Terrier Westie",
      "Wirehaired Pointing Griffon"         => "Wire-haired Pointing Griffon",
      "Yorkie, Yorkshire Terrier"           => "Yorkshire Terrier Yorkie",

      # Cat
      "American Bobtail"                    => "Bobtail",
      "Havana Brown"                        => "Havana",
      "Polydactyl Cat"                      => "Extra-Toes Cat (Hemingway Polydactyl)",
      "Sphynx"                              => "Sphynx (hairless cat)",

      # Rabbit
      "American Chinchilla"                 => "Chinchilla",
      "Blanc de Hotot"                      => "Hotot",
      "Dwarf Hotot"                         => "Dwarf",
      "English Angora"                      => "Angora Rabbit",
      "French Angora"                       => "Angora Rabbit",
      "Giant Angora"                        => "Angora Rabbit",
      "Giant Chinchilla"                    => "Chinchilla",
      "Mini Lop"                            => "Mini-Lop",
      "Mini Satin"                          => "Satin",
      "Satin Angora"                        => "Angora Rabbit",
      "Standard Chinchilla"                 => "Chinchilla",
      "Thrianta"                            => "Havana",

      # Horse
      "Akhal-Teke"                          => "Thoroughbred",
      "American Cream Draft"                => "Draft",
      "American Paint Horse"                => "Paint/Pinto",
      "American Quarter Horse"              => "Quarterhorse",
      "American Saddlebred"                 => "Saddlebred",
      "American Standard Horse"             => "Standardbred",
      "American Warmblood"                  => "Warmblood",
      "Andalusian"                          => "Lipizzan",
      "Belgian Warmblood"                   => "Warmblood",
      "Canadian Sport Horse"                => "Standardbred",
      "Cleveland Bay"                       => "Draft",
      "Danish Warmblood"                    => "Warmblood",
      "Donkey"                              => "Donkey/Mule",
      "Dutch Warmblood"                     => "Warmblood",
      "Friesian"                            => "Draft",
      "Hackney"                             => "Draft",
      "Haflinger"                           => "Draft",
      "Hanoverian Horse"                    => "Draft",
      "Irish Draught Sport Horse"           => "Draft",
      "Missouri Fox Trotter"                => "Missouri Foxtrotter",
      "Morgan Horse"                        => "Morgan",
      "Mountain Horse"                      => "Standardbred",
      "Mule"                                => "Donkey/Mule",
      "Palomino Horse"                      => "Palomino",
      "Pinto Horse"                         => "Paint/Pinto",
      "Racking Horse"                       => "Tennessee Walker",
      "Rocky Mountain Horse"                => "Standardbred",
      "Spotted Saddle Horse"                => "Saddlebred",
      "Standardbred Horse"                  => "Standardbred",
      "Swedish Warmblood"                   => "Warmblood",
      "Tennessee Walking Horse"             => "Tennessee Walker",
      "Welsh Pony"                          => "Pony",

      # Bird
      "African Grey Parrot"                 => "African Grey",
      "Budgerigar"                          => "Budgie/Budgerigar",
      "Lorikeet"                            => "Lory/Lorikeet",
      "Lory"                                => "Lory/Lorikeet",
      "Parakeet"                            => "Parakeet (Other)",
      "Parrot"                              => "Parrot (Other)",
      "Peacock"                             => "Peacock/Pea fowl",
      "Pionus Parrot"                       => "Pionus",
      "Poicephalus"                         => "Poicephalus/Senegal",
      "Ringneck (Psittacula)"               => "Ringneck/Psittacula",
      "Softbill"                            => "Softbill (Other)",

      # Reptile
      "Chameleon"                           => "Lizard",
      "Tortoise"                            => "Turtle",

      # Other
      "Pig"                                 => "Pig (Farm)"
    }
    mapped_breed = local_breeds[breed]
    mapped_breed.present? ? mapped_breed : breed
  end
end

