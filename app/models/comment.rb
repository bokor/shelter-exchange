class Comment < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
   
  # Associations
  belongs_to :shelter
  belongs_to :commentable, :polymorphic => true
   
  # Validations
  validates_presence_of :comment

  # Scopes
end