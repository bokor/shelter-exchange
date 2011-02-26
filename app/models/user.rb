class User < ActiveRecord::Base
  
  ROLES = %w[user admin] #ROLES => Owner(only created on account creation), Admin, User   
    
  # Associations
  belongs_to :account
  
  devise :database_authenticatable, :confirmable, :lockable, :recoverable, 
         :rememberable, :trackable, :lockable, :invitable, :validatable, #:token_authenticatable, 
         :authentication_keys => [ :email, :subdomain ]

         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, 
                  :remember_me, :role, :account_id #, :auth_token
                  
  # Extra Validations
  validates :name, :presence => true
  validates :role, :presence => true
  
  # Scopes
  scope :owner, where(:role => :owner)
  scope :admin, where(:role => :admin)
  scope :user, where(:role => :user)
  
  
  def first_name
    self.name.split(' ').first
  end
  
  def self.find_for_authentication(conditions={})
    conditions[:accounts] = { :subdomain => conditions.delete(:subdomain) }
    find(:first, :conditions => conditions, :joins => :account, :readonly => false)
  end
  
  # def self.find_for_token_authentication(conditions={})
  #   subdomain = User.where(:authentication_token => conditions[:auth_token]).first.account.subdomain
  #   where("users.authentication_token = ? and accounts.subdomain = ?", conditions[token_authentication_key], subdomain).joins(:account).readonly(false).first
  # end
  
end