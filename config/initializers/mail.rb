# ActionMailer::Base.smtp_settings = {
#   :address              => "smtp.gmail.com",
#   :port                 => 587,
#   :domain               => "shelterexchange.org",
#   :user_name            => "brian.bokor@shelterexchange.org",
#   :password             => "aVbYSM4z",
#   :authentication       => "plain",
#   :enable_starttls_auto => true
# }
# 
# ActionMailer::Base.default_url_options[:host] = "localhost:3000"

ActionMailer::Base.smtp_settings = {
  :address  => "localhost",
  :port  => 25,
  :domain  => "www.shelterexchange.local"
  #:user_name  => "me@postoffice.net",
  #:password  => â€œmypassâ€,
  #:authentication  => :login
}
