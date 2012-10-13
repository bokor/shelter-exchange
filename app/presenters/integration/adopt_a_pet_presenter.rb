class Integration::AdoptAPetPresenter < Presenter

  def initialize(animal)
    @animal = animal
  end
  
  def id
    @animal.id
  end
  
  def type
    @animal.other? || @animal.reptile? ? map_to_adopt_a_pet_types : @animal.animal_type.name
  end
  
  def breed
    @animal.primary_breed
  end
  
  def breed2
    @animal.secondary_breed if @animal.dog? || @animal.horse? && @animal.mix_breed?
  end
  
  def name
    @animal.name
  end
  
  def sex
    @animal.sex == 'male' ? 'M' : 'F'
  end
  
  def description
    s = @animal.description.blank? ? 'No description provided' : help.auto_link( help.simple_format(@animal.description), :all, :target => '_blank')
    s << "<br>"
    s << "<a href='#{public_save_a_life_url(@animal, :host=> "www.shelterexchange.org")}'>#{@animal.name}, #{@animal.full_breed}</a> "
    s << "has been shared from <a href='http://www.shelterexchange.org'>Shelter Exchange</a>."
    s << "<link rel='canonical' href='#{public_save_a_life_url(@animal, :host=> "www.shelterexchange.org")}' />"
    s
  end
  
  def status
    'Available'
  end
  
  def purebred
    if @animal.dog? || @animal.rabbit? || @animal.horse?
      @animal.mix_breed? ? 'N' : 'Y'
    end
  end
  
  def special_needs
    @animal.special_needs?  ? 'Y' : 'N'
  end 
  
  def size
    @animal.size unless @animal.size.blank?
  end
  
  def age
    @animal.age.humanize unless @animal.age.blank?
  end
  
  def photos
    photos = []
    unless @animal.photos.blank?
      @animal.photos.each do |photo|
        photos << photo.image.url.gsub(/https:\/\//,"http://") if defined?(photo.image) # replaced https urls with http as there is an issue on adopt-a-pet with secure urls
      end
    end
    (4-@animal.photos.size).times{ photos << nil}
    photos
  end
  
  def you_tube_url
    unless @animal.video_url.blank?
      you_tube_id = @animal.video_url.match(VIDEO_URL_REGEX)[5]
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
      photos, 
      you_tube_url
    ].flatten
  end
  
  def self.csv_header
    [
      'Id',
      'Animal',
      'Breed',
      'Breed2',
      'Name',
      'Sex',
      'Description',
      'Status',
      'Purebred',
      'SpecialNeeds',
      'Size',
      'Age',
      'PhotoURL',
      'PhotoURL2',
      'PhotoURL3',
      'PhotoURL4',
      'YouTubeVideoURL'
    ]
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

    def map_to_adopt_a_pet_types
      types = { 
        'Other' => { 
          'Alpaca' => 'Farm Animal', 
          'Chinchilla' => 'Small Animal', 
          'Cow' => 'Farm Animal',
          'Ferret' => 'Small Animal', 
          'Fish' => 'Reptile', 
          'Frog' => 'Reptile', 
          'Gerbil' => 'Small Animal', 
          'Goat' => 'Farm Animal',
          'Guinea Pig' => 'Small Animal',
          'Hamster' => 'Small Animal',
          'Llama' => 'Farm Animal',
          'Mouse' => 'Small Animal',
          'Pig' => 'Farm Animal',
          'Rat' => 'Small Animal',
          'Sheep' => 'Farm Animal',
          'Tarantula' => 'Reptile' 
        },
        'Reptile' => {
          'Chameleon' => 'Reptile',
          'Gecko' => 'Reptile',
          'Iguana' => 'Reptile',
          'Lizard' => 'Reptile',
          'Snake' => 'Reptile',
          'Tortoise' => 'Reptile',
          'Turtle' => 'Reptile' 
        }
      }
     types[@animal.animal_type.name][@animal.primary_breed]
    end

end