class Photo < ActiveRecord::Base
  # Concerns
  include Guidable
  
  default_scope :order => 'photos.is_main_photo DESC'
  
  # Constants
  #----------------------------------------------------------------------------  
  TOTAL_MAIN = 1
  TOTAL_ADDITIONAL = 3
  MAX_TOTAL = TOTAL_MAIN + TOTAL_ADDITIONAL
  
  # Associations
  #----------------------------------------------------------------------------
  belongs_to :attachable, :polymorphic => true
  
  mount_uploader :image, PhotoUploader
  
  # Validation
  #----------------------------------------------------------------------------
  validate :max_number_of_additional_photos
  
  # Scopes
  #----------------------------------------------------------------------------
  scope :main_photo, where(:is_main_photo => true)
  scope :not_main_photo, where(:is_main_photo => false)
  
  # Instance Methods
  #----------------------------------------------------------------------------
  def attachable?
    self.attachable.present?
  end
  
  def main_photo?
    !!self.is_main_photo
  end
  
  private 
    
    def max_number_of_additional_photos
      unless Photo.not_main_photo.where(:attachable_id => self.attachable, :attachable_type => self.attachable.class.name).count <= TOTAL_ADDITIONAL
        errors.add(:base, "Max number of files exceeded") 
      end
    end
  
end
