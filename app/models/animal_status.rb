class AnimalStatus < ActiveRecord::Base
  
  # Associations
  has_many :animals
  has_many :status_histories, :dependent => :destroy

  # Validations

  # Scopes
  
end
