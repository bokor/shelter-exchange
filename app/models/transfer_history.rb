class TransferHistory < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  # Associations
  belongs_to :transfer, :readonly => true

end
