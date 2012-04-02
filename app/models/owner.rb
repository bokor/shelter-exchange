class Owner < ActiveRecord::Base

  devise :database_authenticatable, :rememberable, 
         :authentication_keys => [ :email ]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
end
