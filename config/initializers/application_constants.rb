US_STATES = { :AK => "Alaska", :AL => "Alabama", :AR => "Arkansas", :AZ => "Arizona", :CA => "California", 
              :CO => "Colorado", :CT => "Connecticut", :DC => "District Of Columbia", :DE => "Delaware", :FL => "Florida", :GA => "Georgia", 
              :HI => "Hawaii", :IA => "Iowa", :ID => "Idaho", :IL => "Illinois", :IN => "Indiana", :KS => "Kansas", :KY => "Kentucky", 
              :LA => "Louisiana", :MA => "Massachusetts", :MD => "Maryland", :ME => "Maine", :MI => "Michigan", :MN => "Minnesota", 
              :MO => "Missouri", :MS => "Mississippi", :MT => "Montana", :NC => "North Carolina", :ND => "North Dakota", 
              :NE => "Nebraska", :NH => "New Hampshire", :NJ => "New Jersey", :NM => "New Mexico", :NV => "Nevada", 
              :NY => "New York", :OH => "Ohio", :OK => "Oklahoma", :OR => "Oregon", :PA => "Pennsylvania", :RI => "Rhode Island", 
              :SC => "South Carolina", :SD => "South Dakota", :TN => "Tennessee", :TX => "Texas", :UT => "Utah", :VA => "Virginia", 
              :VT => "Vermont", :WA => "Washington", :WI => "Wisconsin", :WV => "West Virginia", :WY => "Wyoming" }.freeze

SEX = %w[male female].freeze

EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i  
PHONE_REGEX = /^\+?\d+(-\d+)*$/  # or /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/
URL_REGEX = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
TWITTER_USERNAME_REGEX = /@(?:[a-z0-9]_?)*\z/
PASSWORD_REGEX = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s)$/ 
VIDEO_URL_REGEX = /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v|user)\/))([^\?&"'>]+)/
# ANIMAL_VIDEO_URL_FORMAT = [/^(?:https?:\/\/)?(?:www\.)?youtube\.com(?:\/v\/|\/watch\?v=)([A-Za-z0-9_-]{11})/,
#                            /^(?:https?:\/\/)?(?:www\.)?youtube\.com\/embed\/([A-Za-z0-9_-]{11})/,
#                            /^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([A-Za-z0-9_-]{11})/,
#                            /^(?:https?:\/\/)?(?:www\.)?youtube\.com\/user\/[^\/]+\/?#(?:[^\/]+\/){1,4}([A-Za-z0-9_-]{11})/].freeze

SUBDOMAIN_REGEX = /^[A-Za-z0-9-]+$/
RESERVED_SUBDOMAINS = %w[www support blog wiki billing help api secure authenticate launchpad forum admin manage account accounts user login logout signup register mail ftp pop smtp ssl sftp map maps community communities social administration manager calendar email imap authentication rss atom chat media video videos facebook twitter youtube picture pictures vimeo flickr shelterexchange shelter shelters images image css stylesheets javascript javascripts developer developers development].freeze
# API_VERSION = %w[v1].freeze

HELP_LINK = "http://help.shelterexchange.org"
































