class Setting < ActiveRecord::Base

  # Assocations
  #----------------------------------------------------------------------------
  mount_uploader :adoption_contract, AttachmentUploader

  belongs_to :shelter, :readonly => true
  belongs_to :animal_type, :readonly => true

  # Validations
  #----------------------------------------------------------------------------
  validates :adoption_contract, :presence => true
  validates :animal_type_id, :presence => { :message => "needs to be selected" },
                             :uniqueness => { :scope => :shelter_id, :message => "is already in use" }
end

