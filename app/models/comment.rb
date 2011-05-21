class Comment < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
   
  # Associations
  belongs_to :shelter, :readonly => true
  belongs_to :commentable, :polymorphic => true
   
  # Validations
  validates :comment, :presence => true
   
end
