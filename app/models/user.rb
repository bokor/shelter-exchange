class User < ActiveRecord::Base
  # Associations
  belongs_to :account
  
  acts_as_authentic do |c| 
    c.login_field :email 
    c.validate_login_field false 
    c.validations_scope = :account_id
  end
  
  # Validations
  validates :name, :presence => true
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  
  # Callbacks

  # Scopes
  
  
  
end
