US_STATES = { :AK => "Alaska", :AL => "Alabama", :AR => "Arkansas", :AZ => "Arizona", :CA => "California", 
              :CO => "Colorado", :CT => "Connecticut", :DC => "Washington D.C.", :DE => "Delaware", :FL => "Florida", :GA => "Georgia", 
              :HI => "Hawaii", :IA => "Iowa", :ID => "Idaho", :IL => "Illinois", :IN => "Indiana", :KS => "Kansas", :KY => "Kentucky", 
              :LA => "Louisiana", :MA => "Massachusetts", :MD => "Maryland", :ME => "Maine", :MI => "Michigan", :MN => "Minnesota", 
              :MO => "Missourri", :MS => "Mississippi", :MT => "Montana", :NC => "North Carolina", :ND => "North Dakota", 
              :NE => "Nebraska", :NH => "New Hampshire", :NJ => "New Jersey", :NM => "New Mexico", :NV => "Nevada", 
              :NY => "New York", :OH => "Ohio", :OK => "Oklahoma", :OR => "Oregon", :PA => "Pennsylvania", :RI => "Rhode Island", 
              :SC => "South Carolina", :SD => "South Dakota", :TN => "Tennessee", :TX => "Texas", :UT => "Utah", :VA => "Virginia", 
              :VT => "Vermont", :WA => "Washington", :WI => "Wisconsin", :WV => "West Virginia", :WY => "Wyoming" }.freeze

SEX = %w[male female].freeze

EMAIL_FORMAT = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i  #old one - /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i             
URL_FORMAT = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
PASSWORD_FORMAT = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s)$/ 

SUBDOMAIN_FORMAT = /^[A-Za-z0-9-]+$/
RESERVED_SUBDOMAINS = %w[www support blog wiki billing help api secure authenticate launchpad forum admin manage account accounts user login logout signup register mail ftp pop smtp ssl sftp map maps community communities social administration manager calendar email imap authentication rss atom chat media video videos facebook twitter youtube picture pictures vimeo flickr shelterexchange shelter shelters images image css stylesheets javascript javascripts developer developers development].freeze
# API_VERSION = %w[v1].freeze
































