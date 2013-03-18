class Parent < ActiveRecord::Base
  # Concerns
  include StreetAddressable
  # Parent Namespaced
  include Searchable, Cleanable

  default_scope :order => 'parents.created_at DESC'

  # Associations
  #----------------------------------------------------------------------------
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy

  has_many :animals, :through => :placements
  has_many :shelters, :through => :placements

  # Validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
  validates :phone, :presence => true,  :uniqueness => true, :phone_format => true
  validates :mobile, :uniqueness => true, :phone_format => true, :allow_blank => true
  validates :email, :uniqueness => {:message => "There is an existing Parent associated with these details, please use the 'Look up' to locate the record."},
                    :allow_blank => true, :email_format => true
  validates :email_2, :uniqueness => {:message => "There is an existing Parent associated with these details, please use the 'Look up' to locate the record."},
                      :allow_blank => true, :email_format => true

end
