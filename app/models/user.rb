class User < ActiveRecord::Base
  
  # Associations
  belongs_to :account
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable, :authentication_keys => [:email, :account_id]

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
  
  # Callbacks

  # Scopes
  
  
end
