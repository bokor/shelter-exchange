class TransferHistory < ActiveRecord::Base
  default_scope :order => 'transfer_histories.created_at DESC'

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :transfer, :readonly => true

  # Class Methods
  #----------------------------------------------------------------------------
  def self.create_with(shelter_id, transfer_id, status, reason)
    create!(:shelter_id => shelter_id, :transfer_id => transfer_id, :status => status, :reason => reason)
  end
end
