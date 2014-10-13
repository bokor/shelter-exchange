VIDEO_URL_REGEX = /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v|user)\/))([^\?&"'>]+)/
RESERVED_SUBDOMAINS = %w[www support blog wiki billing help api secure authenticate launchpad forum admin manage account accounts user login logout signup register mail ftp pop smtp ssl sftp map maps community communities social administration manager calendar email imap authentication rss atom chat media video videos facebook twitter youtube picture pictures vimeo flickr shelterexchange shelter shelters images image css stylesheets javascript javascripts developer developers development].freeze

# US States
#----------------------------------------------------------------------------
US_STATES = {
  :AK => "Alaska",
  :AL => "Alabama",
  :AR => "Arkansas",
  :AZ => "Arizona",
  :CA => "California",
  :CO => "Colorado",
  :CT => "Connecticut",
  :DC => "District Of Columbia",
  :DE => "Delaware",
  :FL => "Florida",
  :GA => "Georgia",
  :HI => "Hawaii",
  :IA => "Iowa",
  :ID => "Idaho",
  :IL => "Illinois",
  :IN => "Indiana",
  :KS => "Kansas",
  :KY => "Kentucky",
  :LA => "Louisiana",
  :MA => "Massachusetts",
  :MD => "Maryland",
  :ME => "Maine",
  :MI => "Michigan",
  :MN => "Minnesota",
  :MO => "Missouri",
  :MS => "Mississippi",
  :MT => "Montana",
  :NC => "North Carolina",
  :ND => "North Dakota",
  :NE => "Nebraska",
  :NH => "New Hampshire",
  :NJ => "New Jersey",
  :NM => "New Mexico",
  :NV => "Nevada",
  :NY => "New York",
  :OH => "Ohio",
  :OK => "Oklahoma",
  :OR => "Oregon",
  :PA => "Pennsylvania",
  :RI => "Rhode Island",
  :SC => "South Carolina",
  :SD => "South Dakota",
  :TN => "Tennessee",
  :TX => "Texas",
  :UT => "Utah",
  :VA => "Virginia",
  :VT => "Vermont",
  :WA => "Washington",
  :WI => "Wisconsin",
  :WV => "West Virginia",
  :WY => "Wyoming"
}.freeze
#----------------------------------------------------------------------------


# Dog Breeds
#----------------------------------------------------------------------------
DOG_BREEDS = [
  "Affenpinscher",
  "Afghan Hound",
  "Airedale Terrier",
  "Akbash",
  "Akita",
  "Alaskan Malamute",
  "American Bulldog",
  "American Eskimo Dog",
  "American Foxhound",
  "American Hairless Terrier",
  "American Pit Bull Terrier",
  "American Staffordshire Terrier",
  "American Water Spaniel",
  "Anatolian Shepherd",
  "Appenzell Mountain Dog",
  "Australian Cattle Dog",
  "Australian Kelpie",
  "Australian Shepherd",
  "Australian Terrier",
  "Basenji",
  "Basset Hound",
  "Beagle",
  "Bearded Collie",
  "Beauceron",
  "Bedlington Terrier",
  "Belgian Shepherd - Malinois",
  "Belgian Shepherd - Laekenois",
  "Belgian Shepherd - Sheepdog",
  "Belgian Shepherd - Tervuren",
  "Bernese Mountain Dog",
  "Bichon Frise",
  "Black and Tan Coonhound",
  "Black Mouth Cur",
  "Black Russian Terrier",
  "Bloodhound",
  "Blue Lacy",
  "Blue Heeler",
  "Bluetick Coonhound",
  "Boerboel",
  "Bolognese",
  "Border Collie",
  "Border Terrier",
  "Borzoi",
  "Boston Terrier",
  "Bouvier des Ardennes",
  "Bouvier des Flandres",
  "Boxer",
  "Boykin Spaniel",
  "Briard",
  "Brittany Spaniel",
  "Brussels Griffon",
  "Bull Terrier",
  "Bullmastiff",
  "Cairn Terrier",
  "Canaan Dog",
  "Canadian Eskimo Dog",
  "Cane Corso ",
  "Carolina Dog",
  "Catahoula Cur",
  "Cattle Dog",
  "Caucasian Shepherd Dog",
  "Cavalier King Charles Spaniel",
  "Chesapeake Bay Retriever",
  "Chihuahua",
  "Chinese Crested",
  "Chinook",
  "Chow Chow",
  "Cirneco dell'Etna",
  "Clumber Spaniel",
  "Cocker Spaniel",
  "Collie",
  "Coonhound",
  "Corgi",
  "Coton de Tulear",
  "Curly-Coated Retriever",
  "Dachshund",
  "Dalmatian",
  "Dandi Dinmont Terrier",
  "Doberman Pinscher",
  "Dogo Argentino",
  "Dogue de Bordeaux",
  "Dutch Shepherd",
  "English Bulldog",
  "English Cocker Spaniel",
  "English Coonhound",
  "English Foxhound",
  "English Mastiff",
  "English Pointer",
  "English Setter",
  "English Shepherd",
  "English Springer Spaniel",
  "English Toy Spaniel",
  "Entlebucher Mountain Dog",
  "Eskimo Dog",
  "Feist",
  "Field Spaniel",
  "Fila Brasileiro",
  "Finnish Hound",
  "Finnish Lapphund",
  "Finnish Spitz",
  "Flat-Coated Retriever",
  "Fox Terrier",
  "Foxhound",
  "French Bulldog",
  "French Spaniel",
  "Galgo Spanish Greyhound",
  "German Longhaired Pointer",
  "German Pinscher",
  "German Shepherd Dog",
  "German Shorthaired Pointer",
  "German Spaniel",
  "German Spitz",
  "German Wirehaired Pointer",
  "Giant Schnauzer",
  "Glen of Imaal Terrier",
  "Golden Retriever",
  "Gordon Setter",
  "Great Dane",
  "Great Pyrenees",
  "Greater Swiss Mountain Dog",
  "Greyhound",
  "Halden Hound",
  "Harrier",
  "Havanese",
  "Hound",
  "Hovawart",
  "Husky",
  "Ibizan Hound",
  "Icelandic Sheepdog",
  "Illyrian Sheepdog",
  "Irish Setter",
  "Irish Terrier",
  "Irish Water Spaniel",
  "Irish Wolfhound",
  "Italian Greyhound",
  "Italian Spinone",
  "Jack Russell Terrier",
  "Japanese Chin",
  "Kai Dog",
  "Karelian Bear Dog",
  "Keeshond",
  "Kerry Blue Terrier",
  "King Charles Spaniel",
  "Kishu",
  "Klee Kai",
  "Komondor",
  "Korean Jindo Dog",
  "Kuvasz",
  "Kyi Leo",
  "Labrador Husky",
  "Labrador Retriever",
  "Lakeland Terrier",
  "Lancashire Heeler",
  "Leonberger",
  "Lhasa Apso",
  "Longhaired Whippet",
  "Lowchen",
  "Maltese",
  "Manchester Terrier",
  "Maremma Sheepdog",
  "Mastiff",
  "McNab",
  "Mexican Hairless Dog",
  "Miniature Australian Shepherd",
  "Miniature Fox Terrier",
  "Miniature Pinscher",
  "Miniature Schnauzer",
  "Miniature Siberian Husky",
  "Mountain Cur",
  "Munsterlander",
  "Neapolitan Mastiff",
  "New Guinea Singing Dog",
  "Newfoundland",
  "Norfolk Terrier",
  "Norwegian Buhund",
  "Norwegian Elkhound",
  "Norwegian Lundehund",
  "Norwich Terrier",
  "Nova Scotia Duck-Tolling Retriever",
  "Old English Sheepdog",
  "Otterhound",
  "Papillon",
  "Parson Russell Terrier",
  "Patterdale Terrier (Fell Terrier)",
  "Pekingese",
  "Pembroke Welsh Corgi",
  "Peruvian Inca Orchid",
  "Petit Basset Griffon Vendeen",
  "Pharaoh Hound",
  "Picardy Shepherd",
  "Plott Hound",
  "Podengo Portugueso",
  "Pointer",
  "Polish Lowland Sheepdog",
  "Pomeranian",
  "Poodle",
  "Portuguese Pointer",
  "Portuguese Water Dog",
  "Presa Canario",
  "Pug",
  "Puli",
  "Pumi",
  "Pyrenean Mastiff",
  "Pyrenean Shepherd",
  "Rat Terrier",
  "Redbone Coonhound",
  "Retriever",
  "Rhodesian Ridgeback",
  "Rottweiler",
  "Russian Spaniel",
  "Russian Toy",
  "Saint Bernard",
  "Saluki",
  "Samoyed",
  "Sarplaninac",
  "Schiller Hound",
  "Schipperke",
  "Schnauzer",
  "Scottish Deerhound",
  "Scottish Terrier",
  "Sealyham Terrier",
  "Setter",
  "Shar Pei",
  "Sheep Dog",
  "Shepherd",
  "Sheltie, Shetland Sheepdog",
  "Shiba Inu",
  "Shih Tzu",
  "Shiloh Shepherd Dog",
  "Siberian Husky",
  "Silky Terrier",
  "Skye Terrier",
  "Sloughi",
  "Smooth Fox Terrier",
  "South Russian Ovtcharka",
  "Spanish Mastiff",
  "Spanish Water Dog",
  "Spaniel",
  "Staffordshire Bull Terrier",
  "Standard Poodle",
  "Sussex Spaniel",
  "Swedish Vallhund",
  "Terrier",
  "Thai Ridgeback",
  "Tibetan Mastiff",
  "Tibetan Spaniel",
  "Tibetan Terrier",
  "Tosa Inu",
  "Toy Fox Terrier",
  "Treeing Walker Coonhound",
  "Vizsla",
  "Weimaraner",
  "Welsh Corgi",
  "Welsh Springer Spaniel",
  "Welsh Terrier",
  "Westie, West Highland White Terrier",
  "Wheaten Terrier",
  "Whippet",
  "White German Shepherd",
  "Wire Fox Terrier",
  "Wirehaired Pointing Griffon",
  "Wirehaired Terrier",
  "Yorkie, Yorkshire Terrier"
].freeze
#----------------------------------------------------------------------------


# Cat Breeds
#----------------------------------------------------------------------------
CAT_BREEDS = [
  "Abyssinian",
  "American Bobtail",
  "American Curl",
  "American Shorthair",
  "American Wirehair",
  "Applehead Siamese",
  "Balinese",
  "Bengal",
  "Birman",
  "Bombay",
  "British Longhair",
  "British Shorthair",
  "Burmese",
  "Burmilla",
  "Calico",
  "Canadian Hairless",
  "Chartreux",
  "Chausie",
  "Cornish Rex",
  "Cymric",
  "Devon Rex",
  "Dilute Calico",
  "Dilute Tortoiseshell",
  "Domestic Long Hair",
  "Domestic Medium Hair",
  "Domestic Short Hair",
  "Egyptian Mau",
  "Exotic Shorthair",
  "Havana Brown",
  "Himalayan",
  "Japanese Bobtail",
  "Javanese",
  "Korat",
  "LaPerm",
  "Maine Coon",
  "Manx",
  "Munchkin",
  "Nebelung",
  "Norwegian Forest Cat",
  "Ocicat",
  "Oriental Long Hair",
  "Oriental Short Hair",
  "Oriental Tabby",
  "Persian",
  "Pixie-Bob",
  "Polydactyl Cat",
  "Ragamuffin",
  "Ragdoll",
  "Russian Blue",
  "Scottish Fold",
  "Selkirk Rex",
  "Siamese",
  "Siberian",
  "Singapura",
  "Snowshoe",
  "Somali",
  "Sphynx",
  "Tabby",
  "Tiger",
  "Tonkinese",
  "Torbie",
  "Tortoiseshell",
  "Turkish Angora",
  "Turkish Van",
  "Tuxedo",
  "York Chocolate Cat"
].freeze
#----------------------------------------------------------------------------

# Horse Breeds
#----------------------------------------------------------------------------
HORSE_BREEDS = [
  "Akhal-Teke",
  "American Cream Draft",
  "American Paint Horse",
  "American Quarter Horse",
  "American Saddlebred",
  "American Standard Horse",
  "American Warmblood",
  "Andalusian ",
  "Appaloosa",
  "Arabian",
  "Belgian",
  "Belgian Warmblood",
  "Canadian Sport Horse",
  "Cleveland Bay",
  "Clydesdale",
  "Curly Horse",
  "Danish Warmblood",
  "Donkey",
  "Dutch Warmblood",
  "Draft",
  "Friesian",
  "Gaited",
  "Grade",
  "Hackney",
  "Haflinger",
  "Hanoverian Horse",
  "Irish Draught Sport Horse",
  "Lipizzan",
  "Miniature Horse",
  "Missouri Fox Trotter",
  "Morgan Horse",
  "Mountain Horse",
  "Mule",
  "Mustang",
  "Pinto Horse",
  "Palomino Horse",
  "Paso Fino",
  "Percheron",
  "Peruvian Paso",
  "Pony",
  "Quarterhorse",
  "Racking Horse",
  "Rocky Mountain Horse",
  "Saddlebred",
  "Shetland Pony",
  "Spotted Saddle Horse",
  "Standardbred Horse",
  "Swedish Warmblood",
  "Tennessee Walking Horse",
  "Thoroughbred",
  "Warmblood",
  "Welsh Pony"
].freeze
#----------------------------------------------------------------------------

# Rabbit Breeds
#----------------------------------------------------------------------------
RABBIT_BREEDS = [
  "American",
  "American Chinchilla",
  "American Fuzzy Lop",
  "American Sable",
  "Belgian Hare",
  "Beveren",
  "Blanc de Hotot",
  "Britannia Petite",
  "Bunny Rabbit",
  "Californian",
  "Champagne D'Argent",
  "Checkered Giant",
  "Cinnamon",
  "Creme D'Argent",
  "Dutch",
  "Dwarf Hotot",
  "English Angora",
  "English Lop",
  "English Spot",
  "Flemish Giant",
  "Florida White",
  "French Angora",
  "French-Lop",
  "Giant Angora",
  "Giant Chinchilla",
  "Harlequin",
  "Havana",
  "Himalayan",
  "Holland Lop",
  "Hotot",
  "Jersey Wooly",
  "Lilac",
  "Lionhead",
  "Mini Lop",
  "Mini Rex",
  "Mini Satin",
  "Netherland Dwarf",
  "New Zealand",
  "Palomino",
  "Polish",
  "Rex",
  "Rhinelander",
  "Satin",
  "Satin Angora",
  "Silver",
  "Silver Fox",
  "Silver Marten",
  "Standard Chinchilla",
  "Tan",
  "Thrianta"
].freeze
#----------------------------------------------------------------------------

# Bird Breeds
#----------------------------------------------------------------------------
BIRD_BREEDS = [
  "African Grey Parrot",
  "Amazon",
  "Brotogeris",
  "Budgerigar",
  "Button Quail",
  "Caique",
  "Canary",
  "Chicken",
  "Cockatiel",
  "Cockatoo",
  "Conure",
  "Dove",
  "Duck",
  "Eclectus",
  "Emu",
  "Finch",
  "Goose",
  "Guinea fowl",
  "Kakariki",
  "Lorikeet",
  "Lory",
  "Lovebird",
  "Macaw",
  "Mynah",
  "Ostrich",
  "Parakeet",
  "Parrot",
  "Parrotlet",
  "Peacock",
  "Pheasant",
  "Pigeon",
  "Pionus Parrot",
  "Poicephalus",
  "Quail",
  "Quaker Parakeet",
  "Rhea",
  "Ringneck (Psittacula)",
  "Rosella",
  "Softbill",
  "Swan",
  "Toucan",
  "Turkey"
].freeze
#----------------------------------------------------------------------------

# Reptile Breeds
#----------------------------------------------------------------------------
REPTILE_BREEDS = [
  "Chameleon",
  "Gecko",
  "Iguana",
  "Lizard",
  "Snake",
  "Tortoise",
  "Turtle"
].freeze
#----------------------------------------------------------------------------

# Other Breeds
#----------------------------------------------------------------------------
OTHER_BREEDS = [
  "Alpaca",
  "Chinchilla",
  "Cow",
  "Ferret",
  "Fish",
  "Frog",
  "Gerbil",
  "Goat",
  "Guinea Pig",
  "Hamster",
  "Llama",
  "Mouse",
  "Pig",
  "Rat",
  "Sheep",
  "Sugar Glider",
  "Tarantula"
].freeze
#----------------------------------------------------------------------------

