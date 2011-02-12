class User < ActiveRecord::Base
  
  ROLES = %w[user admin] #ROLES => Owner(only created on account creation), Admin, User 
    
  # Associations
  belongs_to :account
  
  devise :database_authenticatable, :recoverable, :rememberable, 
         :trackable, :validatable, :token_authenticatable, :confirmable, :invitable
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :auth_token, :role, :account_id#, :subdomain 
  #attr_accessor :subdomain
  
  # Validations
  validates :name, :presence => true
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => EMAIL_FORMAT}
  # validates :password, :presence => true,
  #                      :length => {:minimum => 6, :maximum => 25},
  #                      :format => { :with => /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s)$/ }
  

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

#  Another Alternative
#
# def self.find_for_authentication(conditions={})
#   conditions[:account_id] = Account.find_by_subdomain(conditions.delete(:subdomain)).id
#   find(:first, :conditions => conditions)
# end

# Reference for other conditions
#
# def self.find_for_authentication(conditions={})
#     # unless conditions[:subdomain] == "dashboard" 
#     logger::error("::::: SUBDOMAIN #{conditions.delete(:subdomain)}")
#       conditions[:accounts] = { :subdomain => conditions.delete(:subdomain) }
#       find(:first, :conditions => conditions, :joins => :account)
#     # else #if the user access the dashboard subdomain he can log in any of his accounts, so I remove the subdomain from the conditions, then it won't be used in the authentication process
#       # conditions.delete(:subdomain)
#       # find(:first, :conditions => conditions)
#     # end
#   end

# Token Login Reference
#
# def self.valid?(params)
#   token_user = self.where(:auth_token => params[:id]).first
#   if token_user
#     token_user.auth_token = nil
#     token_user.save
#   end
#   return token_user
# end