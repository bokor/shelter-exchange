class User < ActiveRecord::Base
  
  ROLES = %w[user admin] #ROLES => Owner(only created on account creation), Admin, User 
    
  # Associations
  belongs_to :account
  
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :token_authenticatable, :confirmable, :invitable, :lockable #, :validatable NOT SURE ABOUT THIS
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :auth_token, :role, :account_id#, :subdomain 
  #attr_accessor :subdomain
  
  # Validations
  validates :name, :presence => true
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => EMAIL_FORMAT}
  # validates :password, :presence => true, #{ :message => "something" },
  #                        :length => {:minimum => 6, :maximum => 25 }, #:message => "something" },
  #                        :format => { :with => PASSWORD_FORMAT } #, :message => "something" }
  

  # Scopes
  
  
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