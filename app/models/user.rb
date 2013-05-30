class User < ActiveRecord::Base

  # Constants
  #----------------------------------------------------------------------------
  ROLES = %w[user admin].freeze #ROLES => Owner(only created on account creation), Admin, User
  OWNER = "owner"

  # Callbacks
  #----------------------------------------------------------------------------
  before_create :hide_announcements_by_default

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :account, :readonly => true
  has_many :shelters, :through => :account

  devise :database_authenticatable, :recoverable, :token_authenticatable,
         :rememberable, :trackable, :lockable, :invitable, :validatable,
         :authentication_keys => [:email],
         :request_keys => [:subdomain]

  # Getters/Setters
  #----------------------------------------------------------------------------
  attr_accessible :name, :title, :email, :password, :password_confirmation, :authentication_token,
                  :remember_me, :role, :account_id, :announcement_hide_time

  # Validations - Extra beyond devise's validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true

  # Scopes
  #----------------------------------------------------------------------------
  scope :owner, where(:role => :owner)
  scope :admin, where(:role => :admin)
  scope :default, where(:role => :user)
  scope :admin_list, joins(:shelters).
                     select("users.name as name, users.email as email, shelters.id as shelter_id, shelters.name as shelter_name").
                     order("shelters.name").limit(250)

  # Instance Methods
  #----------------------------------------------------------------------------
  def first_name
    self.name.split(' ').first
  end

  def last_name
    self.name.split(' ').last
  end

  def is?(role)
    self.role == role.to_s and (ROLES.include?(role.to_s) or role.to_s == OWNER)
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.find_for_authentication(conditions={})
    account = Account.find_by_subdomain(conditions.delete(:subdomain))
    conditions[:account_id] = account.id if account
    super(conditions)
  end

  def self.valid_token?(token)
    token_user = self.where(:authentication_token => token).first
    if token_user
      token_user.authentication_token = nil
      token_user.save
    end
    return token_user
  end

  def self.admin_live_search(q)
    scope = self.scoped
    scope = scope.admin_list
    scope = scope.where("users.name LIKE ? or users.email LIKE ?", "%#{q}%", "%#{q}%") unless q.blank?
    scope
  end


  #----------------------------------------------------------------------------
  private

  def hide_announcements_by_default
    self.announcement_hide_time = Time.now.utc
  end
end

