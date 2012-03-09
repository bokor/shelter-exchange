class User < ActiveRecord::Base
  
  # Constants
  #----------------------------------------------------------------------------
  ROLES = %w[user admin].freeze #ROLES => Owner(only created on account creation), Admin, User  
  OWNER = "owner"

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :account
  
  devise :database_authenticatable, :recoverable, :token_authenticatable, #:confirmable, :lockable 
         :rememberable, :trackable, :lockable, :invitable, :validatable, 
         :authentication_keys => [ :email, :subdomain ]

         
  # Getters/Setters
  #----------------------------------------------------------------------------
  attr_accessible :name, :title, :email, :password, :password_confirmation, :authentication_token, 
                  :remember_me, :role, :account_id, :announcement_hide_time
                  
                  
  # Validations - Extra beyond devise's validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
  validates :role, :presence => { :message => "needs to be selected" }
  
  # Scopes
  #----------------------------------------------------------------------------
  scope :owner, where(:role => :owner)
  scope :admin, where(:role => :admin)
  scope :default, where(:role => :user)
  scope :admin_list, joins(:account => :shelters).
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
    subdomain = conditions.delete(:subdomain)
    self.select("users.*").joins(:account).where(conditions).where("accounts.subdomain = ?", subdomain).first
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
    scope = scope.where("users.name LIKE LOWER('%#{q}%') or users.email LIKE LOWER('%#{q}%')") unless q.blank?
    scope
  end
  
end
# OLD WAY
# def self.find_for_authentication(conditions={})
#   conditions[:accounts] = { :subdomain => conditions.delete(:subdomain) }
#   find(:first, :conditions => conditions, :joins => :account, :readonly => false)
# end
# def self.find_for_database_authentication(conditions)
#   subdomain = conditions.delete(:subdomain)
#   self.select("users.*").joins(:account).where(conditions).where("accounts.subdomain = ?", subdomain).first
# end