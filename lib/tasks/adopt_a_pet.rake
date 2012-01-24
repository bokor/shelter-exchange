require 'csv'
include Rails.application.routes.url_helpers

# Constants
#----------------------------------------------------------------------------
ADOPT_A_PET_TYPES = { "Other" => { 
                          "Alpaca" => "Farm Animal",
                          "Chinchilla" => "Small Animal",
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
                          "Tarantula" => "Reptile" },
                      "Reptile" => {
                          "Chameleon" => "Reptile",
                          "Gecko" => "Reptile",
                          "Iguana" => "Reptile",
                          "Lizard" => "Reptile",
                          "Snake" => "Reptile",
                          "Tortoise" => "Reptile",
                          "Turtle" => "Reptile" }
                    }

TASK_START_TIME = Time.now
SHELTER_START_TIME = 0
LOG_FILENAME = Rails.root.join("log/adopt_a_pet_rake_task.log")
CSV_FILENAME = Rails.root.join("tmp/pets.csv")
CFG_FILENAME = Rails.root.join("public/integrations/adopt_a_pet/import.cfg")


# Tasks
#----------------------------------------------------------------------------
namespace :adopt_a_pet do
  
  desc "Creating Adopt a Pet CSV files"
  task :generate_csv_files => :environment do
    
    @integrations = Integration::AdoptAPet.all
    
    @integrations.each do |integration|
      SHELTER_START_TIME = Time.now
      
      @shelter = integration.shelter
      @animals = @shelter.animals.includes(:animal_type).available_for_adoption.limit(nil).all
      
      CSV.open(CSV_FILENAME, "w+") do |csv|
        
        csv << ["Id","Animal","Breed","Breed2","Name","Sex","Description","Status","PhotoURL","Purebred","SpecialNeeds","Size","Age"]
      
        @animals.each do |animal|
          csv << csv_animal_row(animal)
        end 
        
      end 
      
      # FTP Files to Adopt a Pet
      ftp_files_to_adopt_a_pet(integration.username, integration.password)
      
      # Log Shelter name and how long it took for each shelter
      logger.info("#{@shelter.name} finished in #{Time.now - SHELTER_START_TIME}")
    end #Integrations Each
    
  end
  
  desc "Creating Adopt a Pet CSV files"
  task :all => [:generate_csv_files] do 
    logger.info("Time elapsed: #{Time.now - TASK_START_TIME} seconds.")
  end
  
end


# Local Methods
#----------------------------------------------------------------------------
def logger
  @logger ||= Logger.new( File.open(LOG_FILENAME, "w+") )
end

def ftp_files_to_adopt_a_pet(username, password)
  Net::FTP.open(Integration::AdoptAPet::FTP_URL) do |ftp|
    ftp.login(username, password)
    ftp.passive = true
    ftp.puttextfile(CSV_FILENAME)
    ftp.puttextfile(CFG_FILENAME)
  end
end

def csv_animal_row(animal)
  id            = animal.id
  type          = animal.other? || animal.reptile? ? ADOPT_A_PET_TYPES[animal.animal_type.name][animal.primary_breed] : animal.animal_type.name
  breed         = animal.primary_breed
  breed2        = animal.secondary_breed if animal.dog? || animal.horse? && animal.mix_breed?
  name          = animal.name
  sex           = animal.sex == "male" ? "M" : "F"
  description   = description_mapping(animal)
  status        = "Available"
  photo         = animal.photo.url(:large) unless animal.photo.url(:large).include?("default_large_photo")
  purebred      = if animal.dog? || animal.rabbit? || animal.horse?
                    animal.mix_breed? ? "N" : "Y"
                  end
  special_needs = animal.special_needs?  ? "Y" : "N"
  size          = size_mapping(animal.size) unless animal.size.blank?
  age           = age_mapping(animal.animal_type.name, animal.date_of_birth) unless animal.date_of_birth.blank?
  
  [id, type, breed, breed2, name, sex, description, status, photo, purebred, special_needs, size, age]
end

def description_mapping(animal)
  tmp = animal.description
  tmp << "<br /><br /> "
  tmp << "<a href='#{public_save_a_life_url(animal, :host=> "www.shelterexchange.org")}'>#{animal.name}, #{animal.full_breed}</a> full profile "
  tmp << "has been shared from <a href='http://www.shelterexchange.org'>Shelter Exchange</a>."
  tmp << "<link rel='canonical' href='#{public_save_a_life_url(animal, :host=> "www.shelterexchange.org")}' />"
  tmp
end

def size_mapping(size)
  tmp = size.downcase
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

def age_mapping(type, date_of_birth)
  months = months_between(Date.today, date_of_birth)
  case type
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

# Helper Methods
#----------------------------------------------------------------------------
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


