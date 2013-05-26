class Parent < ActiveRecord::Base
  include StreetAddressable

  default_scope :order => 'parents.created_at DESC'

  # Callbacks
  #----------------------------------------------------------------------------
  before_save :clean_fields

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

  # Class Methods
  #----------------------------------------------------------------------------
  def search(q, parent_params)
    phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")

    scope = self.scoped
    scope = scope.where("phone = ? OR mobile = ? OR email = ? OR email_2 = ? OR name like ?", phone, phone, q, q, "%#{q}%")
    scope = scope.where(parent_params)
    scope
  end

  #----------------------------------------------------------------------------
  private

  def clean_fields
    clean_phone_numbers
  end

  def clean_phone_numbers
    [:phone, :mobile].each do |type|
      self.send(type).gsub(/\D/, "") if self.respond_to?(type) and self.send(type).present?
    end
  end
end
