class Integration::PetfinderPresenter < Presenter

  PETFINDER_TYPES = { 
                        "Other" => { 
                          "Alpaca" => "Farm Animal", "Chinchilla" => "Small Animal", "Cow" => "Farm Animal",
                          "Ferret" => "Small Animal", "Fish" => "Reptile", "Frog" => "Reptile", "Gerbil" => "Small Animal", "Goat" => "Farm Animal",
                          "Guinea Pig" => "Small Animal","Hamster" => "Small Animal","Llama" => "Farm Animal","Mouse" => "Small Animal",
                          "Pig" => "Farm Animal","Rat" => "Small Animal","Sheep" => "Farm Animal","Tarantula" => "Reptile" },
                        "Reptile" => {
                          "Chameleon" => "Reptile","Gecko" => "Reptile","Iguana" => "Reptile","Lizard" => "Reptile",
                          "Snake" => "Reptile","Tortoise" => "Reptile","Turtle" => "Reptile" }
                      }

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

  # TODO ::
  def age
    unless @animal.date_of_birth.blank?
      months = months_between(Date.today, @animal.date_of_birth)
      case @animal.animal_type.name
        when "Dog"
          if months <= 12
            "Baby"
          elsif months > 12 and months <= 36
            "Young"
          elsif months > 36 and months <= 96
            "Adult"
          elsif months > 96 
            "Senior"
          end
        when "Cat"
          if months <= 12
            "Baby"
          elsif months > 12 and months <= 36
            "Young"
          elsif months > 36 and months <= 84
            "Adult"
          elsif months > 84
            "Senior"
          end
        when "Horse"
          if months <= 12
            "Baby"
          elsif months > 12 and months <= 36
            "Young"
          elsif months > 36 and months <= 168
            "Adult"
          elsif months > 168
            "Senior"
          end
        when "Rabbit"
          if months <= 1
            "Baby"
          elsif months > 1 and months <= 7
            "Young"
          elsif months > 7 and months <= 60
            "Adult"
          elsif months > 60
            "Senior"
          end
        else
          nil
      end
    end
  end

  # TO DO ::
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
    "A"
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
      @animal.photos.each do |photo|
        photos << photo.image.url.gsub(/https:\/\//,"http://") if defined?(photo.image) # replaced https urls with http as there is an issue on adopt-a-pet with secure urls
      end
    end
    (4-@animal.photos.size).times{ photos << nil }
    photos
  end
  
  # def you_tube_url
  #   unless @animal.video_url.blank?
  #     you_tube_id = @animal.video_url.match(VIDEO_URL_REGEX)[5]
  #     "http://www.youtube.com/watch?v=#{you_tube_id}" unless you_tube_id.blank?
  #   end
  # end 

  def to_csv
    [id, '', name, breed, breed2, sex, size, age, description, type, status, '', altered, '', '', '', '', '', special_needs, mix, nil, nil, nil].flatten
  end
  
  def self.csv_header
    ["ID","Internal","AnimalName","PrimaryBreed","SecondaryBreed","Sex","Size","Age","Desc","Type","Status","Shots","Altered","NoDogs","NoCats","NoKids","Housetrained","Declawed","specialNeeds","Mix","photo1","photo2","photo3"]
  end
  
  private

    def months_between(from_time, to_time)
      from_time = from_time.to_time if from_time.respond_to?(:to_time)
      to_time = to_time.to_time if to_time.respond_to?(:to_time)
      distance_in_seconds = ((to_time - from_time).abs).round

      if distance_in_seconds >= 1.month
        delta = (distance_in_seconds / 1.month).floor
        distance_in_seconds -= delta.month
        delta
      end

      delta.blank? ? 0 : delta.to_i

    end

end