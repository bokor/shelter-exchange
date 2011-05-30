class TransferHistory < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  # Associations
  belongs_to :transfer, :readonly => true
  
  def self.create_with(shelter_id, transfer_id, status, reason)
    transfer_history = TransferHistory.new(:shelter_id => shelter_id, :transfer_id => transfer_id, :status => status, :reason => reason)
    transfer_history.save
  end

end
