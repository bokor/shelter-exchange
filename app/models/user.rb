class User < ActiveRecord::Base
  
  # Associations
  belongs_to :account
  
  devise :database_authenticatable, :recoverable, :rememberable, #:registerable,
         :trackable, :validatable, :token_authenticatable, :confirmable, :invitable # should be in the devise.rb file, :authentication_keys => [:email, :account_id]
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :account_id, :auth_token
  
  # Validations
  validates :name, :presence => true
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  # validates :password, :presence => true,
  #                      :length => {:minimum => 6, :maximum => 25},
  #                      :format => { :with => /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s)$/ }
  

  # Scopes
  
  def self.valid?(params)
    token_user = self.where(:auth_token => params[:id]).first
    if token_user
      token_user.auth_token = nil
      token_user.save
    end
    return token_user
  end
  
  
end
