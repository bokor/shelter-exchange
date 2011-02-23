class User < ActiveRecord::Base
  
  ROLES = %w[user admin] #ROLES => Owner(only created on account creation), Admin, User 
    
  # Associations
  belongs_to :account
  
  devise :database_authenticatable, :confirmable, :lockable, :recoverable, :rememberable, :trackable,
         :token_authenticatable, :lockable, :invitable, :validatable

         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, 
                  :remember_me, :auth_token, :role, :account_id
  
  # Extra Validations
  validates :name, :presence => true
  validates :role, :presence => true
  
  # Scopes
  
  
  def first_name
    self.name.split(' ').first
  end
  
  # def self.find_for_authentication(conditions={})
  #     conditions[:accounts] = { :subdomain => conditions.delete(:subdomain) }
  #     find(:first, :conditions => conditions, :joins => :account, :readonly => false)
  #   end
  


  # protected
  #   def password_required?
  #    false
  #  end
   
   
  
  # def self.find_for_authentication(conditions={})
  #   unless conditions[:subdomain].blank?
  #     conditions[:accounts] = { :subdomain => conditions.delete(:subdomain) }
  #     find(:first, :conditions => conditions, :joins => :account, :readonly => false)
  #   else
  #     conditions.delete(:subdomain)
  #     find(:first, :conditions => conditions)
  #   end
  # end
  
end