class User < ActiveRecord::Base
  
  # Constants
  #----------------------------------------------------------------------------
  ROLES = %w[user admin].freeze #ROLES => Owner(only created on account creation), Admin, User  
  OWNER = "owner"

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :account
  
  devise :database_authenticatable, :confirmable, :recoverable, :token_authenticatable, #:lockable 
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
    self.select("users.*").joins(:account).where(conditions).where("accounts.subdomain = ?", subdomain).limit(1).first
    super
  end
  
  def self.valid_token?(token)
    token_user = self.where(:authentication_token => token).first
    if token_user
      token_user.authentication_token = nil
      token_user.save
    end
    return token_user
  end
  
end
