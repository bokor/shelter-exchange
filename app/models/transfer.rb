class Transfer < ActiveRecord::Base
  
  STATUSES = %w(approve reject)
  
  # Associations
  belongs_to :from_shelter, :class_name => "Shelter", :readonly => true
  belongs_to :to_shelter, :class_name => "Shelter", :readonly => true
  belongs_to :animal, :readonly => true
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  accepts_nested_attributes_for :comments, :allow_destroy => true, :reject_if => proc { |attributes| attributes['comment'].blank? }
  
end
