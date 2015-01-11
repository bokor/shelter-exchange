# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in DeviseMailer.
  config.mailer_sender = "ShelterExchange <do-not-reply@shelterexchange.org>"

  # ==> ORM configuration

  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  config.secret_key = '1a2975969fa840fa7b644cef6e9cff959c149e90f7a5828222f1f31f07480e6814ce20239d944077b091224b232634ca94b7a61e5fcfbbc443982284c3f7b311'

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [ :email ]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [ :email ]

  # ==> Configuration for :invitable
  # The period the generated invitation token is valid, after
  # this period, the invited resource won't be able to accept the invitation.
  # When invite_for is 0 (the default), the invitation won't expire.
  config.invite_for = 0

  # Flag that force a record to be valid before being actually invited
  # Default: false
  config.validate_on_invite = true

  # ==> Configuration for :validatable
  # Range for password length. Default is 6..128.
  config.password_length = 6..128

  # Regex to use to validate the email address
  config.email_regexp = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  # ==> Configuration for :recoverable

  # Time interval you can reset your password with a reset password key.
  # Don't put a too small interval or your users won't have the time to
  # change their passwords.
  config.reset_password_within = 2.hours

  # ==> Scopes configuration

  # Turn scoped views on. Before rendering "sessions/new", it will first check for
  # "users/sessions/new". It's turned off by default because it's slower if you
  # are using only default views.
  config.scoped_views = true

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes (usually :user).
  config.default_scope = :user

  # ==> Navigation configuration
  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete
end

