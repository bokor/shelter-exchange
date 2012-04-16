class Integration::AdoptAPetPresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper

  ADOPT_A_PET_TYPES = { 
                        "Other" => { 
                          "Alpaca" => "Farm Animal", "Chinchilla" => "Small Animal", "Cow" => "Farm Animal",
                          "Ferret" => "Small Animal", "Fish" => "Reptile", "Frog" => "Reptile", "Gerbil" => "Small Animal", "Goat" => "Farm Animal",
                          "Guinea Pig" => "Small Animal","Hamster" => "Small Animal","Llama" => "Farm Animal","Mouse" => "Small Animal",
                          "Pig" => "Farm Animal","Rat" => "Small Animal","Sheep" => "Farm Animal","Tarantula" => "Reptile" },
                        "Reptile" => {
                          "Chameleon" => "Reptile","Gecko" => "Reptile","Iguana" => "Reptile","Lizard" => "Reptile",
                          "Snake" => "Reptile","Tortoise" => "Reptile","Turtle" => "Reptile" }
                      }

  def initialize( animal )
    @animal = animal
  end
  
  def id
    @animal.id
  end
  
  def type
    @animal.other? || @animal.reptile? ? ADOPT_A_PET_TYPES[@animal.animal_type.name][@animal.primary_breed] : @animal.animal_type.name
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
    @animal.sex == "male" ? "M" : "F"
  end
  
  def description
    s = @animal.description.blank? ? "No description provided" : auto_link( simple_format(@animal.description), :all, :target => "_blank")
    s << "<br>"
    s << "<a href='#{public_save_a_life_url(@animal, :host=> "www.shelterexchange.org")}'>#{@animal.name}, #{@animal.full_breed}</a> "
    s << "has been shared from <a href='http://www.shelterexchange.org'>Shelter Exchange</a>."
    s << "<link rel='canonical' href='#{public_save_a_life_url(@animal, :host=> "www.shelterexchange.org")}' />"
    s
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
    @animal.special_needs?  ? "Y" : "N"
  end 
  
  def size
    unless @animal.size.blank?
      tmp = @animal.size.downcase
      if tmp.include?("x-large")
        "XL"
      elsif tmp.include?("large")
        "L"
      elsif tmp.include?("medium")
        "M"
      elsif tmp.include?("small")
        "S"
      end
    end
  end
  
  def age
    unless @animal.date_of_birth.blank?
      months = months_between(Date.today, @animal.date_of_birth)
      case @animal.animal_type.name
        when "Dog"
          if months <= 12
            "Puppy"
          elsif months > 12 and months <= 36
            "Young"
          elsif months > 36 and months <= 96
            "Adult"
          elsif months > 96 
            "Senior"
          end
        when "Cat"
          if months <= 12
            "Kitten"
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
  
  def photo
    @animal.photo.url(:large) unless @animal.photo.url(:large).include?("default_large_photo")
  end
  
  def you_tube_url
    unless @animal.video_url.blank?
      you_tube_id = .match(VIDEO_URL_REGEX)[5]
      "http://www.youtube.com/watch?v=#{you_tube_id}" unless you_tube_id.blank?
    end
  end 

  def to_csv
    [id, type, breed, breed2, name, sex, description, status, purebred, special_needs, size, age, photo, you_tube_url]
  end
  
  def self.csv_header
      ["Id","Animal","Breed","Breed2","Name","Sex","Description","Status","Purebred","SpecialNeeds","Size","Age","PhotoURL","YouTubeVideoURL"]
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
    
    def controller
      nil #included this method because of the action view helpers
    end

end