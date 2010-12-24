# -*- coding: utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


def truncate_db_table(table)
      config = ActiveRecord::Base.configurations[Rails.env]
      ActiveRecord::Base.establish_connection
      case config["adapter"]
        when "mysql"
          ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
        when "sqlite", "sqlite3"
          ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
          ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
          ActiveRecord::Base.connection.execute("VACUUM")
      end
end

#######################################################################################################################
#
#   Truncate All Database Tables data
#
#######################################################################################################################
truncate_db_table("animals")
truncate_db_table("animal_types")
truncate_db_table("animal_statuses")
truncate_db_table("breeds")
truncate_db_table("notes")
truncate_db_table("note_categories")
truncate_db_table("alerts")
truncate_db_table("tasks")
truncate_db_table("task_categories")

#######################################################################################################################
#
#   AnimalType Create
#      Creates the AnimalType Categories so that we have a standard set of Animal Types
#
#######################################################################################################################
dog     = AnimalType.create( :name => "Dog" )
cat     = AnimalType.create( :name => "Cat" )
horse   = AnimalType.create( :name => "Horse" )
rabbit  = AnimalType.create( :name => "Rabbit" )
bird    = AnimalType.create( :name => "Bird" )
reptile = AnimalType.create( :name => "Reptile" )
other   = AnimalType.create( :name => "Other" )


#######################################################################################################################
#
#   AnimalStatus Create
#      Creates the AnimalStaus Categories so that we have a standard set of Statuses
#
#######################################################################################################################
AnimalStatus.create([
  { :name => "Available for Adoption" },
  { :name => "Adopted" },
  { :name => "Foster Care" },
  { :name => "New Intake" },
  { :name => "In Transit" },
  { :name => "On Hold - Behavioral" },
  { :name => "On Hold - Medical" },
  { :name => "On Hold - Stray Intake" },
  { :name => "Reclaim" },
  { :name => "Deceased" },
  { :name => "Euthanized" }
])
 


#######################################################################################################################
#
#   Breed Create
#      Creates the AnimalType Categories so that we have a standard set of Animal Types
#
#######################################################################################################################

### DOG ###############################################################################################################
Breed.create([
  { :animal_type_id => dog.id, :name => "Affenpinscher" },
  { :animal_type_id => dog.id, :name => "Afghan Hound" },
  { :animal_type_id => dog.id, :name => "Airedale Terrier" },
  { :animal_type_id => dog.id, :name => "Akbash" },
  { :animal_type_id => dog.id, :name => "Akita" },
  { :animal_type_id => dog.id, :name => "Aidi" },
  { :animal_type_id => dog.id, :name => "Alaskan Malamute" },
  { :animal_type_id => dog.id, :name => "American Bulldog" },
  { :animal_type_id => dog.id, :name => "American Eskimo Dog" },
  { :animal_type_id => dog.id, :name => "American Foxhound" },
  { :animal_type_id => dog.id, :name => "American Hairless Terrier" },
  { :animal_type_id => dog.id, :name => "American Staffordshire Terrier" },
  { :animal_type_id => dog.id, :name => "American Water Spaniel" },
  { :animal_type_id => dog.id, :name => "Anatolian Shepherd" },
  { :animal_type_id => dog.id, :name => "Appenzell Mountain Dog" },
  { :animal_type_id => dog.id, :name => "Australian Cattle Dog" },
  { :animal_type_id => dog.id, :name => "Australian Kelpie" },
  { :animal_type_id => dog.id, :name => "Australian Shepherd" },
  { :animal_type_id => dog.id, :name => "Australian Terrier" },
  { :animal_type_id => dog.id, :name => "Basenji" },
  { :animal_type_id => dog.id, :name => "Basset Hound" },
  { :animal_type_id => dog.id, :name => "Beagle" },
  { :animal_type_id => dog.id, :name => "Bearded Collie" },
  { :animal_type_id => dog.id, :name => "Beauceron" },
  { :animal_type_id => dog.id, :name => "Bedlington Terrier" },
  { :animal_type_id => dog.id, :name => "Belgian Shepherd - Malinois" },
  { :animal_type_id => dog.id, :name => "Belgian Shepherd - Laekenois" },
  { :animal_type_id => dog.id, :name => "Belgian Shepherd - Sheepdog" },
  { :animal_type_id => dog.id, :name => "Belgian Shepherd - Tervuren" },
  { :animal_type_id => dog.id, :name => "Bernese Mountain Dog" },
  { :animal_type_id => dog.id, :name => "Bichon Frise" },
  { :animal_type_id => dog.id, :name => "Black and Tan Coonhound" },
  { :animal_type_id => dog.id, :name => "Black Mouth Cur" },
  { :animal_type_id => dog.id, :name => "Black Russian Terrier" },
  { :animal_type_id => dog.id, :name => "Bloodhound" },
  { :animal_type_id => dog.id, :name => "Blue Lacy" },
  { :animal_type_id => dog.id, :name => "Bluetick Coonhound" },
  { :animal_type_id => dog.id, :name => "Boerboel" },
  { :animal_type_id => dog.id, :name => "Bolognese" },
  { :animal_type_id => dog.id, :name => "Border Collie" },
  { :animal_type_id => dog.id, :name => "Border Terrier" },
  { :animal_type_id => dog.id, :name => "Borzoi" },
  { :animal_type_id => dog.id, :name => "Boston Terrier" },
  { :animal_type_id => dog.id, :name => "Bouvier des Ardennes" },
  { :animal_type_id => dog.id, :name => "Bouvier des Flandres" },
  { :animal_type_id => dog.id, :name => "Boxer" },
  { :animal_type_id => dog.id, :name => "Boykin Spaniel" },
  { :animal_type_id => dog.id, :name => "Briard" },
  { :animal_type_id => dog.id, :name => "Brittany Spaniel" },
  { :animal_type_id => dog.id, :name => "Brussels Griffon" },
  { :animal_type_id => dog.id, :name => "Bull Terrier" },
  { :animal_type_id => dog.id, :name => "Bullmastiff" },
  { :animal_type_id => dog.id, :name => "Cairn Terrier" },
  { :animal_type_id => dog.id, :name => "Canaan Dog" },
  { :animal_type_id => dog.id, :name => "Canadian Eskimo Dog" },
  { :animal_type_id => dog.id, :name => "Cane Corso " },
  { :animal_type_id => dog.id, :name => "Carolina Dog" },
  { :animal_type_id => dog.id, :name => "Catahoula Cur" },
  { :animal_type_id => dog.id, :name => "Cattle Dog" },
  { :animal_type_id => dog.id, :name => "Caucasian Shepherd Dog" },
  { :animal_type_id => dog.id, :name => "Cavalier King Charles Spaniel" },
  { :animal_type_id => dog.id, :name => "Chesapeake Bay Retriever" },
  { :animal_type_id => dog.id, :name => "Chihuahua" },
  { :animal_type_id => dog.id, :name => "Chinese Crested Dog" },
  { :animal_type_id => dog.id, :name => "Chinook" },
  { :animal_type_id => dog.id, :name => "Chow Chow" },
  { :animal_type_id => dog.id, :name => "Cirneco dell'Etna" },
  { :animal_type_id => dog.id, :name => "Clumber Spaniel" },
  { :animal_type_id => dog.id, :name => "Cocker Spaniel" },
  { :animal_type_id => dog.id, :name => "Collie" },
  { :animal_type_id => dog.id, :name => "Coonhound" },
  { :animal_type_id => dog.id, :name => "Corgi" },
  { :animal_type_id => dog.id, :name => "Coton de Tulear" },
  { :animal_type_id => dog.id, :name => "Curly-Coated Retriever" },
  { :animal_type_id => dog.id, :name => "Dachshund" },
  { :animal_type_id => dog.id, :name => "Dalmatian" },
  { :animal_type_id => dog.id, :name => "Dandi Dinmont Terrier" },
  { :animal_type_id => dog.id, :name => "Doberman Pinscher" },
  { :animal_type_id => dog.id, :name => "Dogo Argentino" },
  { :animal_type_id => dog.id, :name => "Dogue de Bordeaux" },
  { :animal_type_id => dog.id, :name => "Dutch Shepherd" },
  { :animal_type_id => dog.id, :name => "English Bulldog" },
  { :animal_type_id => dog.id, :name => "English Cocker Spaniel" },
  { :animal_type_id => dog.id, :name => "English Coonhound" },
  { :animal_type_id => dog.id, :name => "English Foxhound" },
  { :animal_type_id => dog.id, :name => "English Mastiff" },
  { :animal_type_id => dog.id, :name => "English Pointer" },
  { :animal_type_id => dog.id, :name => "English Setter" },
  { :animal_type_id => dog.id, :name => "English Shepherd" },
  { :animal_type_id => dog.id, :name => "English Springer Spaniel" },
  { :animal_type_id => dog.id, :name => "English Toy Spaniel" },
  { :animal_type_id => dog.id, :name => "Entlebucher Mountain Dog" },
  { :animal_type_id => dog.id, :name => "Eskimo Dog" },
  { :animal_type_id => dog.id, :name => "Feist" },
  { :animal_type_id => dog.id, :name => "Field Spaniel" },
  { :animal_type_id => dog.id, :name => "Finnish Hound" },
  { :animal_type_id => dog.id, :name => "Finnish Lapphund" },
  { :animal_type_id => dog.id, :name => "Finnish Spitz" },
  { :animal_type_id => dog.id, :name => "Flat-Coated Retriever" },
  { :animal_type_id => dog.id, :name => "Fox Terrier" },
  { :animal_type_id => dog.id, :name => "Foxhound" },
  { :animal_type_id => dog.id, :name => "French Bulldog" },
  { :animal_type_id => dog.id, :name => "French Spaniel" },
  { :animal_type_id => dog.id, :name => "Galgo Spanish Greyhound" },
  { :animal_type_id => dog.id, :name => "German Longhaired Pointer" },
  { :animal_type_id => dog.id, :name => "German Pinscher" },
  { :animal_type_id => dog.id, :name => "German Shepherd Dog" },
  { :animal_type_id => dog.id, :name => "German Shorthaired Pointer" },
  { :animal_type_id => dog.id, :name => "German Spaniel" },
  { :animal_type_id => dog.id, :name => "German Spitz" },
  { :animal_type_id => dog.id, :name => "German Wirehaired Pointer" },
  { :animal_type_id => dog.id, :name => "Giant Schnauzer" },
  { :animal_type_id => dog.id, :name => "Glen of Imaal Terrier" },
  { :animal_type_id => dog.id, :name => "Golden Retriever" },
  { :animal_type_id => dog.id, :name => "Gordon Setter" },
  { :animal_type_id => dog.id, :name => "Great Dane" },
  { :animal_type_id => dog.id, :name => "Great Pyrenees" },
  { :animal_type_id => dog.id, :name => "Greater Swiss Mountain Dog" },
  { :animal_type_id => dog.id, :name => "Greyhound" },
  { :animal_type_id => dog.id, :name => "Harrier" },
  { :animal_type_id => dog.id, :name => "Havanese" },
  { :animal_type_id => dog.id, :name => "Hound" },
  { :animal_type_id => dog.id, :name => "Hovawart" },
  { :animal_type_id => dog.id, :name => "Husky" },
  { :animal_type_id => dog.id, :name => "Ibizan Hound" },
  { :animal_type_id => dog.id, :name => "Icelandic Sheepdog" },
  { :animal_type_id => dog.id, :name => "Illyrian Sheepdog" },
  { :animal_type_id => dog.id, :name => "Irish Setter" },
  { :animal_type_id => dog.id, :name => "Irish Terrier" },
  { :animal_type_id => dog.id, :name => "Irish Water Spaniel" },
  { :animal_type_id => dog.id, :name => "Irish Wolfhound" },
  { :animal_type_id => dog.id, :name => "Italian Greyhound" },
  { :animal_type_id => dog.id, :name => "Italian Spinone" },
  { :animal_type_id => dog.id, :name => "Jack Russell Terrier" },
  { :animal_type_id => dog.id, :name => "Japanese Chin" },
  { :animal_type_id => dog.id, :name => "Kai Dog" },
  { :animal_type_id => dog.id, :name => "Karelian Bear Dog" },
  { :animal_type_id => dog.id, :name => "Keeshond" },
  { :animal_type_id => dog.id, :name => "Kerry Blue Terrier" },
  { :animal_type_id => dog.id, :name => "King Charles Spaniel" },
  { :animal_type_id => dog.id, :name => "Kishu" },
  { :animal_type_id => dog.id, :name => "Klee Kai" },
  { :animal_type_id => dog.id, :name => "Komondor" },
  { :animal_type_id => dog.id, :name => "Korean Jindo Dog" },
  { :animal_type_id => dog.id, :name => "Kuvasz" },
  { :animal_type_id => dog.id, :name => "Kyi Leo" },
  { :animal_type_id => dog.id, :name => "Labrador Husky" },
  { :animal_type_id => dog.id, :name => "Labrador Retriever" },
  { :animal_type_id => dog.id, :name => "Lakeland Terrier" },
  { :animal_type_id => dog.id, :name => "Lancashire Heeler" },
  { :animal_type_id => dog.id, :name => "Leonberger" },
  { :animal_type_id => dog.id, :name => "Lhasa Apso" },
  { :animal_type_id => dog.id, :name => "Longhaired Whippet" },
  { :animal_type_id => dog.id, :name => "Lowchen" },
  { :animal_type_id => dog.id, :name => "Maltese" },
  { :animal_type_id => dog.id, :name => "Manchester Terrier" },
  { :animal_type_id => dog.id, :name => "Maremma Sheepdog" },
  { :animal_type_id => dog.id, :name => "Mastiff" },
  { :animal_type_id => dog.id, :name => "McNab" },
  { :animal_type_id => dog.id, :name => "Mexican Hairless Dog" },
  { :animal_type_id => dog.id, :name => "Miniature Australian Shepherd" },
  { :animal_type_id => dog.id, :name => "Miniature Fox Terrier" },
  { :animal_type_id => dog.id, :name => "Miniature Pinscher" },
  { :animal_type_id => dog.id, :name => "Miniature Schnauzer" },
  { :animal_type_id => dog.id, :name => "Miniature Siberian Husky" },
  { :animal_type_id => dog.id, :name => "Mountain Cur" },
  { :animal_type_id => dog.id, :name => "Mountain Dog" },
  { :animal_type_id => dog.id, :name => "Munsterlander - Large" },
  { :animal_type_id => dog.id, :name => "Munsterlander - Small" },
  { :animal_type_id => dog.id, :name => "Neapolitan Mastiff" },
  { :animal_type_id => dog.id, :name => "New Guinea Singing Dog" },
  { :animal_type_id => dog.id, :name => "Newfoundland Dog" },
  { :animal_type_id => dog.id, :name => "Norfolk Terrier" },
  { :animal_type_id => dog.id, :name => "Norwegian Buhund" },
  { :animal_type_id => dog.id, :name => "Norwegian Elkhound" },
  { :animal_type_id => dog.id, :name => "Norwegian Lundehund" },
  { :animal_type_id => dog.id, :name => "Norwich Terrier" },
  { :animal_type_id => dog.id, :name => "Nova Scotia Duck-Tolling Retriever" },
  { :animal_type_id => dog.id, :name => "Old English Sheepdog" },
  { :animal_type_id => dog.id, :name => "Olde English Bulldogge" },
  { :animal_type_id => dog.id, :name => "Otterhound" },
  { :animal_type_id => dog.id, :name => "Papillon" },
  { :animal_type_id => dog.id, :name => "Parson Russell Terrier" },
  { :animal_type_id => dog.id, :name => "Patterdale Terrier (Fell Terrier)" },
  { :animal_type_id => dog.id, :name => "Pekingese" },
  { :animal_type_id => dog.id, :name => "Pembroke Welsh Corgi" },
  { :animal_type_id => dog.id, :name => "Peruvian Inca Orchid" },
  { :animal_type_id => dog.id, :name => "Petit Basset Griffon Vendeen" },
  { :animal_type_id => dog.id, :name => "Pharaoh Hound" },
  { :animal_type_id => dog.id, :name => "Picardy Shepherd" },
  { :animal_type_id => dog.id, :name => "Pit Bull Terrier" },
  { :animal_type_id => dog.id, :name => "Plott Hound" },
  { :animal_type_id => dog.id, :name => "Podengo Portugueso" },
  { :animal_type_id => dog.id, :name => "Pointer" },
  { :animal_type_id => dog.id, :name => "Polish Lowland Sheepdog" },
  { :animal_type_id => dog.id, :name => "Pomeranian" },
  { :animal_type_id => dog.id, :name => "Poodle" },
  { :animal_type_id => dog.id, :name => "Portuguese Pointer" },
  { :animal_type_id => dog.id, :name => "Portuguese Water Dog" },
  { :animal_type_id => dog.id, :name => "Presa Canario" },
  { :animal_type_id => dog.id, :name => "Pug" },
  { :animal_type_id => dog.id, :name => "Puli" },
  { :animal_type_id => dog.id, :name => "Pumi" },
  { :animal_type_id => dog.id, :name => "Pyrenean Mastiff" },
  { :animal_type_id => dog.id, :name => "Pyrenean Shepherd" },
  { :animal_type_id => dog.id, :name => "Rat Terrier" },
  { :animal_type_id => dog.id, :name => "Redbone Coonhound" },
  { :animal_type_id => dog.id, :name => "Retriever" },
  { :animal_type_id => dog.id, :name => "Rhodesian Ridgeback" },
  { :animal_type_id => dog.id, :name => "Rottweiler" },
  { :animal_type_id => dog.id, :name => "Russian Spaniel" },
  { :animal_type_id => dog.id, :name => "Russian Toy" },
  { :animal_type_id => dog.id, :name => "Saint Bernard St. Bernard" },
  { :animal_type_id => dog.id, :name => "Saluki" },
  { :animal_type_id => dog.id, :name => "Samoyed" },
  { :animal_type_id => dog.id, :name => "Sarplaninac" },
  { :animal_type_id => dog.id, :name => "Schipperke" },
  { :animal_type_id => dog.id, :name => "Schnauzer " },
  { :animal_type_id => dog.id, :name => "Scottish Deerhound" },
  { :animal_type_id => dog.id, :name => "Scottish Terrier" },
  { :animal_type_id => dog.id, :name => "Sealyham Terrier" },
  { :animal_type_id => dog.id, :name => "Setter" },
  { :animal_type_id => dog.id, :name => "Shar Pei" },
  { :animal_type_id => dog.id, :name => "Sheep Dog" },
  { :animal_type_id => dog.id, :name => "Shepherd" },
  { :animal_type_id => dog.id, :name => "Shetland Sheepdog " },
  { :animal_type_id => dog.id, :name => "Shiba Inu" },
  { :animal_type_id => dog.id, :name => "Shih Tzu" },
  { :animal_type_id => dog.id, :name => "Shiloh Shepherd Dog" },
  { :animal_type_id => dog.id, :name => "Siberian Husky" },
  { :animal_type_id => dog.id, :name => "Silky Terrier" },
  { :animal_type_id => dog.id, :name => "Skye Terrier" },
  { :animal_type_id => dog.id, :name => "Sloughi" },
  { :animal_type_id => dog.id, :name => "Smooth Fox Terrier" },
  { :animal_type_id => dog.id, :name => "South Russian Ovtcharka" },
  { :animal_type_id => dog.id, :name => "Spanish Mastiff" },
  { :animal_type_id => dog.id, :name => "Spanish Water Dog" },
  { :animal_type_id => dog.id, :name => "Spaniel" },
  { :animal_type_id => dog.id, :name => "Staffordshire Bull Terrier" },
  { :animal_type_id => dog.id, :name => "Standard Poodle" },
  { :animal_type_id => dog.id, :name => "Sussex Spaniel" },
  { :animal_type_id => dog.id, :name => "Swedish Vallhund" },
  { :animal_type_id => dog.id, :name => "Terrier" },
  { :animal_type_id => dog.id, :name => "Thai Ridgeback" },
  { :animal_type_id => dog.id, :name => "Tibetan Mastiff" },
  { :animal_type_id => dog.id, :name => "Tibetan Spaniel" },
  { :animal_type_id => dog.id, :name => "Tibetan Terrier" },
  { :animal_type_id => dog.id, :name => "Toy Fox Terrier" },
  { :animal_type_id => dog.id, :name => "Treeing Walker Coonhound" },
  { :animal_type_id => dog.id, :name => "Vizsla" },
  { :animal_type_id => dog.id, :name => "Weimaraner" },
  { :animal_type_id => dog.id, :name => "Welsh Corgi" },
  { :animal_type_id => dog.id, :name => "Welsh Springer Spaniel" },
  { :animal_type_id => dog.id, :name => "Welsh Terrier" },
  { :animal_type_id => dog.id, :name => "West Highland White Terrier " },
  { :animal_type_id => dog.id, :name => "Wheaten Terrier" },
  { :animal_type_id => dog.id, :name => "Whippet" },
  { :animal_type_id => dog.id, :name => "White German Shepherd" },
  { :animal_type_id => dog.id, :name => "Wire Fox Terrier" },
  { :animal_type_id => dog.id, :name => "Wirehaired Pointing Griffon" },
  { :animal_type_id => dog.id, :name => "Wirehaired Terrier" },
  { :animal_type_id => dog.id, :name => "Yorkshire Terrier" }
])

### CAT ###############################################################################################################
Breed.create([
  { :animal_type_id => cat.id, :name => "Abyssinian" },
  { :animal_type_id => cat.id, :name => "American Bobtail" },
  { :animal_type_id => cat.id, :name => "American Curl" },
  { :animal_type_id => cat.id, :name => "American Shorthair" },
  { :animal_type_id => cat.id, :name => "American Wirehair" },
  { :animal_type_id => cat.id, :name => "Applehead Siamese" },
  { :animal_type_id => cat.id, :name => "Balinese" },
  { :animal_type_id => cat.id, :name => "Bengal" },
  { :animal_type_id => cat.id, :name => "Birman" },
  { :animal_type_id => cat.id, :name => "Bombay" },
  { :animal_type_id => cat.id, :name => "British Longhair" },
  { :animal_type_id => cat.id, :name => "British Shorthair" },
  { :animal_type_id => cat.id, :name => "Burmese" },
  { :animal_type_id => cat.id, :name => "Burmilla" },
  { :animal_type_id => cat.id, :name => "Calico" },
  { :animal_type_id => cat.id, :name => "Canadian Hairless" },
  { :animal_type_id => cat.id, :name => "Chartreux" },
  { :animal_type_id => cat.id, :name => "Chausie" },
  { :animal_type_id => cat.id, :name => "Chinchilla" },
  { :animal_type_id => cat.id, :name => "Cornish Rex" },
  { :animal_type_id => cat.id, :name => "Cymric" },
  { :animal_type_id => cat.id, :name => "Devon Rex" },
  { :animal_type_id => cat.id, :name => "Dilute Calico" },
  { :animal_type_id => cat.id, :name => "Dilute Tortoiseshell" },
  { :animal_type_id => cat.id, :name => "Domestic Long Hair" },
  { :animal_type_id => cat.id, :name => "Domestic Medium Hair" },
  { :animal_type_id => cat.id, :name => "Domestic Short Hair" },
  { :animal_type_id => cat.id, :name => "Egyptian Mau" },
  { :animal_type_id => cat.id, :name => "Exotic Shorthair" },
  { :animal_type_id => cat.id, :name => "Havana Brown" },
  { :animal_type_id => cat.id, :name => "Himalayan" },
  { :animal_type_id => cat.id, :name => "Japanese Bobtail" },
  { :animal_type_id => cat.id, :name => "Javanese" },
  { :animal_type_id => cat.id, :name => "Korat" },
  { :animal_type_id => cat.id, :name => "LaPerm" },
  { :animal_type_id => cat.id, :name => "Maine Coon" },
  { :animal_type_id => cat.id, :name => "Manx" },
  { :animal_type_id => cat.id, :name => "Munchkin" },
  { :animal_type_id => cat.id, :name => "Nebelung" },
  { :animal_type_id => cat.id, :name => "Norwegian Forest Cat" },
  { :animal_type_id => cat.id, :name => "Ocicat" },
  { :animal_type_id => cat.id, :name => "Oriental Long Hair" },
  { :animal_type_id => cat.id, :name => "Oriental Short Hair" },
  { :animal_type_id => cat.id, :name => "Oriental Tabby" },
  { :animal_type_id => cat.id, :name => "Persian" },
  { :animal_type_id => cat.id, :name => "Pixie-Bob" },
  { :animal_type_id => cat.id, :name => "Polydactyl Cat" },
  { :animal_type_id => cat.id, :name => "Ragamuffin" },
  { :animal_type_id => cat.id, :name => "Ragdoll" },
  { :animal_type_id => cat.id, :name => "Russian Blue" },
  { :animal_type_id => cat.id, :name => "Scottish Fold" },
  { :animal_type_id => cat.id, :name => "Selkirk Rex" },
  { :animal_type_id => cat.id, :name => "Siamese" },
  { :animal_type_id => cat.id, :name => "Siberian" },
  { :animal_type_id => cat.id, :name => "Silver" },
  { :animal_type_id => cat.id, :name => "Singapura" },
  { :animal_type_id => cat.id, :name => "Snowshoe" },
  { :animal_type_id => cat.id, :name => "Somali" },
  { :animal_type_id => cat.id, :name => "Sphynx" },
  { :animal_type_id => cat.id, :name => "Tabby" },
  { :animal_type_id => cat.id, :name => "Tiger" },
  { :animal_type_id => cat.id, :name => "Tonkinese" },
  { :animal_type_id => cat.id, :name => "Torbie" },
  { :animal_type_id => cat.id, :name => "Tortoiseshell" },
  { :animal_type_id => cat.id, :name => "Turkish Angora" },
  { :animal_type_id => cat.id, :name => "Turkish Van" },
  { :animal_type_id => cat.id, :name => "Tuxedo" },
  { :animal_type_id => cat.id, :name => "York Chocolate Cat" }
])

### HORSE ##############################################################################################################
Breed.create([
  { :animal_type_id => horse.id, :name => "Akhal-Teke" },
  { :animal_type_id => horse.id, :name => "American Cream Draft" },
  { :animal_type_id => horse.id, :name => "American Paint Horse" },
  { :animal_type_id => horse.id, :name => "American Quarter Horse" },
  { :animal_type_id => horse.id, :name => "American Saddlebred" },
  { :animal_type_id => horse.id, :name => "American Standard Horse" },
  { :animal_type_id => horse.id, :name => "American Warmblood" },
  { :animal_type_id => horse.id, :name => "Andalusian " },
  { :animal_type_id => horse.id, :name => "Appaloosa" },
  { :animal_type_id => horse.id, :name => "Arabian" },
  { :animal_type_id => horse.id, :name => "Belgian" },
  { :animal_type_id => horse.id, :name => "Belgian Warmblood" },
  { :animal_type_id => horse.id, :name => "Canadian Sport Horse" },
  { :animal_type_id => horse.id, :name => "Cleveland Bay" },
  { :animal_type_id => horse.id, :name => "Clydesdale" },
  { :animal_type_id => horse.id, :name => "Curly Horse" },
  { :animal_type_id => horse.id, :name => "Danish Warmblood" },
  { :animal_type_id => horse.id, :name => "Donkey" },
  { :animal_type_id => horse.id, :name => "Dutch Warmblood" },
  { :animal_type_id => horse.id, :name => "Draft" },
  { :animal_type_id => horse.id, :name => "Friesian" },
  { :animal_type_id => horse.id, :name => "Gaited" },
  { :animal_type_id => horse.id, :name => "Grade" },
  { :animal_type_id => horse.id, :name => "Hackney" },
  { :animal_type_id => horse.id, :name => "Haflinger" },
  { :animal_type_id => horse.id, :name => "Hanoverian Horse" },
  { :animal_type_id => horse.id, :name => "Irish Draught Sport Horse" },
  { :animal_type_id => horse.id, :name => "Lipizzan" },
  { :animal_type_id => horse.id, :name => "Miniature Horse" },
  { :animal_type_id => horse.id, :name => "Missouri Fox Trotter" },
  { :animal_type_id => horse.id, :name => "Morgan Horse" },
  { :animal_type_id => horse.id, :name => "Mountain Horse" },
  { :animal_type_id => horse.id, :name => "Mule" },
  { :animal_type_id => horse.id, :name => "Mustang" },
  { :animal_type_id => horse.id, :name => "Pinto Horse" },
  { :animal_type_id => horse.id, :name => "Palomino Horse" },
  { :animal_type_id => horse.id, :name => "Paso Fino" },
  { :animal_type_id => horse.id, :name => "Percheron" },
  { :animal_type_id => horse.id, :name => "Peruvian Paso" },
  { :animal_type_id => horse.id, :name => "Pony" },
  { :animal_type_id => horse.id, :name => "Quarterhorse" },
  { :animal_type_id => horse.id, :name => "Racking Horse" },
  { :animal_type_id => horse.id, :name => "Rocky Mountain Horse" },
  { :animal_type_id => horse.id, :name => "Saddlebred" },
  { :animal_type_id => horse.id, :name => "Shetland Pony" },
  { :animal_type_id => horse.id, :name => "Spotted Saddle Horse" },
  { :animal_type_id => horse.id, :name => "Standardbred Horse" },
  { :animal_type_id => horse.id, :name => "Swedish Warmblood" },
  { :animal_type_id => horse.id, :name => "Tennessee Walking Horse" },
  { :animal_type_id => horse.id, :name => "Thoroughbred" },
  { :animal_type_id => horse.id, :name => "Warmblood" },
  { :animal_type_id => horse.id, :name => "Welsh Pony" }
])

### RABBIT ############################################################################################################
Breed.create([
  { :animal_type_id => rabbit.id, :name => "American" },
  { :animal_type_id => rabbit.id, :name => "American Chinchilla" },
  { :animal_type_id => rabbit.id, :name => "American Fuzzy Lop" },
  { :animal_type_id => rabbit.id, :name => "American Sable" },
  { :animal_type_id => rabbit.id, :name => "Belgian Hare" },
  { :animal_type_id => rabbit.id, :name => "Beveren" },
  { :animal_type_id => rabbit.id, :name => "Blanc de Hotot" },
  { :animal_type_id => rabbit.id, :name => "Britannia Petite" },
  { :animal_type_id => rabbit.id, :name => "Californian" },
  { :animal_type_id => rabbit.id, :name => "Champagne D'Argent" },
  { :animal_type_id => rabbit.id, :name => "Checkered Giant" },
  { :animal_type_id => rabbit.id, :name => "Chinchilla" },
  { :animal_type_id => rabbit.id, :name => "Cinnamon" },
  { :animal_type_id => rabbit.id, :name => "Creme D'Argent" },
  { :animal_type_id => rabbit.id, :name => "Dutch" },
  { :animal_type_id => rabbit.id, :name => "Dwarf Hotot" },
  { :animal_type_id => rabbit.id, :name => "English Angora" },
  { :animal_type_id => rabbit.id, :name => "English Lop" },
  { :animal_type_id => rabbit.id, :name => "English Spot" },
  { :animal_type_id => rabbit.id, :name => "Flemish Giant" },
  { :animal_type_id => rabbit.id, :name => "Florida White" },
  { :animal_type_id => rabbit.id, :name => "French Angora" },
  { :animal_type_id => rabbit.id, :name => "French-Lop" },
  { :animal_type_id => rabbit.id, :name => "Giant Angora" },
  { :animal_type_id => rabbit.id, :name => "Giant Chinchilla" },
  { :animal_type_id => rabbit.id, :name => "Harlequin" },
  { :animal_type_id => rabbit.id, :name => "Havana" },
  { :animal_type_id => rabbit.id, :name => "Himalayan" },
  { :animal_type_id => rabbit.id, :name => "Holland Lop" },
  { :animal_type_id => rabbit.id, :name => "Hotot" },
  { :animal_type_id => rabbit.id, :name => "Jersey Wooly" },
  { :animal_type_id => rabbit.id, :name => "Lilac" },
  { :animal_type_id => rabbit.id, :name => "Lionhead" },
  { :animal_type_id => rabbit.id, :name => "Mini Lop" },
  { :animal_type_id => rabbit.id, :name => "Mini Rex" },
  { :animal_type_id => rabbit.id, :name => "Mini Satin" },
  { :animal_type_id => rabbit.id, :name => "Netherland Dwarf" },
  { :animal_type_id => rabbit.id, :name => "New Zealand" },
  { :animal_type_id => rabbit.id, :name => "Palomino" },
  { :animal_type_id => rabbit.id, :name => "Polish" },
  { :animal_type_id => rabbit.id, :name => "Rex" },
  { :animal_type_id => rabbit.id, :name => "Rhinelander" },
  { :animal_type_id => rabbit.id, :name => "Satin" },
  { :animal_type_id => rabbit.id, :name => "Satin Angora" },
  { :animal_type_id => rabbit.id, :name => "Silver" },
  { :animal_type_id => rabbit.id, :name => "Silver Fox" },
  { :animal_type_id => rabbit.id, :name => "Silver Marten" },
  { :animal_type_id => rabbit.id, :name => "Standard Chinchilla" },
  { :animal_type_id => rabbit.id, :name => "Tan" },
  { :animal_type_id => rabbit.id, :name => "Thrianta" }
])

### BIRD ##############################################################################################################
Breed.create([
  { :animal_type_id => bird.id, :name => "African Grey Parrot" },
  { :animal_type_id => bird.id, :name => "Amazon" },
  { :animal_type_id => bird.id, :name => "Brotogeris" },
  { :animal_type_id => bird.id, :name => "Budgerigar" },
  { :animal_type_id => bird.id, :name => "Button Quail" },
  { :animal_type_id => bird.id, :name => "Caique" },
  { :animal_type_id => bird.id, :name => "Canary" },
  { :animal_type_id => bird.id, :name => "Chicken" },
  { :animal_type_id => bird.id, :name => "Cockatiel" },
  { :animal_type_id => bird.id, :name => "Cockatoo" },
  { :animal_type_id => bird.id, :name => "Conure" },
  { :animal_type_id => bird.id, :name => "Dove" },
  { :animal_type_id => bird.id, :name => "Duck" },
  { :animal_type_id => bird.id, :name => "Eclectus" },
  { :animal_type_id => bird.id, :name => "Emu" },
  { :animal_type_id => bird.id, :name => "Finch" },
  { :animal_type_id => bird.id, :name => "Goose" },
  { :animal_type_id => bird.id, :name => "Guinea fowl" },
  { :animal_type_id => bird.id, :name => "Kakariki" },
  { :animal_type_id => bird.id, :name => "Lorikeet" },
  { :animal_type_id => bird.id, :name => "Lory" },
  { :animal_type_id => bird.id, :name => "Lovebird" },
  { :animal_type_id => bird.id, :name => "Macaw" },
  { :animal_type_id => bird.id, :name => "Mynah" },
  { :animal_type_id => bird.id, :name => "Ostrich" },
  { :animal_type_id => bird.id, :name => "Parakeet " },
  { :animal_type_id => bird.id, :name => "Parrot" },
  { :animal_type_id => bird.id, :name => "Parrotlet" },
  { :animal_type_id => bird.id, :name => "Peacock" },
  { :animal_type_id => bird.id, :name => "Pheasant" },
  { :animal_type_id => bird.id, :name => "Pigeon" },
  { :animal_type_id => bird.id, :name => "Pionus Parrot" },
  { :animal_type_id => bird.id, :name => "Poicephalus" },
  { :animal_type_id => bird.id, :name => "Quail" },
  { :animal_type_id => bird.id, :name => "Quaker Parakeet" },
  { :animal_type_id => bird.id, :name => "Rhea" },
  { :animal_type_id => bird.id, :name => "Ringneck (Psittacula)" },
  { :animal_type_id => bird.id, :name => "Rosella" },
  { :animal_type_id => bird.id, :name => "Softbill " },
  { :animal_type_id => bird.id, :name => "Swan" },
  { :animal_type_id => bird.id, :name => "Toucan" },
  { :animal_type_id => bird.id, :name => "Turkey" }
])

### REPTILE ###########################################################################################################
Breed.create([
  { :animal_type_id => reptile.id, :name => "Chameleon" },
  { :animal_type_id => reptile.id, :name => "Dragon" },
  { :animal_type_id => reptile.id, :name => "Gecko" },
  { :animal_type_id => reptile.id, :name => "Iguana" },
  { :animal_type_id => reptile.id, :name => "Lizard" },
  { :animal_type_id => reptile.id, :name => "Snake" },
  { :animal_type_id => reptile.id, :name => "Tortoise" },
  { :animal_type_id => reptile.id, :name => "Turtle" }
])

### OTHER #############################################################################################################
Breed.create([
  { :animal_type_id => other.id, :name => "Alpaca" },
  { :animal_type_id => other.id, :name => "Chinchilla" },
  { :animal_type_id => other.id, :name => "Cow" },
  { :animal_type_id => other.id, :name => "Crab" },
  { :animal_type_id => other.id, :name => "Ferret" },
  { :animal_type_id => other.id, :name => "Fish" },
  { :animal_type_id => other.id, :name => "Frog" },
  { :animal_type_id => other.id, :name => "Gerbil" },
  { :animal_type_id => other.id, :name => "Goat" },
  { :animal_type_id => other.id, :name => "Guinea Pig" },
  { :animal_type_id => other.id, :name => "Hamster" },
  { :animal_type_id => other.id, :name => "Llama" },
  { :animal_type_id => other.id, :name => "Mouse" },
  { :animal_type_id => other.id, :name => "Pig" },
  { :animal_type_id => other.id, :name => "Rat" },
  { :animal_type_id => other.id, :name => "Sheep" },
  { :animal_type_id => other.id, :name => "Spider" }
])

#######################################################################################################################
#
#   NoteCategory Create
#      Creates the NoteCategories so that we have a standard set of notes
#
#######################################################################################################################
NoteCategory.create([
  { :name => "General" },
  { :name => "Medical" },
  { :name => "Behavioral" }
])

# general = NoteCategory.find_by_name("General")
# medical = NoteCategory.find_by_name("Medical")
# behavior = NoteCategory.find_by_name("Behavior")
# 
# NoteCategory.create([
#   { :name => "General Test A", :parent_id => general.id },
#   { :name => "General Test B", :parent_id => general.id },
#   { :name => "Medical Test A", :parent_id => medical.id },
#   { :name => "Medical Test B", :parent_id => medical.id },
#   { :name => "Behavior Test A", :parent_id => behavior.id },
#   { :name => "Behavior Test B", :parent_id => behavior.id }
# ])

#######################################################################################################################
#
#   TaskCategory Create
#      Creates the TaskCategory so that we have a standard set of TaskCategories
#
#######################################################################################################################
TaskCategory.create([
  { :name => "Call", :color => "#cc1d0a" },
  { :name => "Email", :color => "#0871a5" },
  { :name => "Follow-up", :color => "#cc610a" },
  { :name => "Meeting", :color => "#9108a5" },
  { :name => "To-do", :color => "#08a535" },
  { :name => "Educational", :color => "#ccaf0a" },
  { :name => "Behavioral", :color => "#b4094a" },
  { :name => "Medical", :color => "#0833a6" }
])