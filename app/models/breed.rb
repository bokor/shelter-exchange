class Breed < ActiveRecord::Base
  
  # Associations
  belongs_to :animal_type, :readonly => true

  # Validations

  # Scopes
  
  scope :auto_complete, lambda { |type, q|  where("animal_type_id = ? AND LOWER(name) LIKE LOWER(?)", type, "%#{q}%") }
  # 
  # scope :since, lambda {|time| {:conditions => ["created_at > ?", time] }}
  # scope :since, lambda {|time| where("created_at > ?", time) }
end
