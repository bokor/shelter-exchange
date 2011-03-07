class User < ActiveRecord::Base
  
  # Constants 
  ROLES = %w[user admin] #ROLES => Owner(only created on account creation), Admin, User  
  OWNER = "owner"

  # Associations
  belongs_to :account
  
  devise :database_authenticatable, :confirmable, :lockable, :recoverable, 
         :rememberable, :trackable, :lockable, :invitable, :validatable, 
         :authentication_keys => [ :email, :subdomain ]

         
  # Accessible Attributes
  attr_accessible :name, :email, :password, :password_confirmation, 
                  :remember_me, :role, :account_id 
                  
  # Validations - Extra beyond devise's validations
  validates :name, :presence => true
  validates :role, :presence => true
  
  # Scopes
  scope :owner, where(:role => :owner)
  scope :admin, where(:role => :admin)
  scope :user, where(:role => :user)
  
  
  def first_name
    self.name.split(' ').first
  end
  
  def is?(role)
    self.role == role.to_s and (ROLES.include?(role.to_s) or role.to_s == OWNER)
  end
  
  def self.find_for_authentication(conditions={})
    conditions[:accounts] = { :subdomain => conditions.delete(:subdomain) }
    find(:first, :conditions => conditions, :joins => :account, :readonly => false)
  end
  
end

#:token_authenticatable, 
#, :auth_token
# def self.find_for_token_authentication(conditions={})
#   subdomain = User.where(:authentication_token => conditions[:auth_token]).first.account.subdomain
#   where("users.authentication_token = ? and accounts.subdomain = ?", conditions[token_authentication_key], subdomain).joins(:account).readonly(false).first
# end
