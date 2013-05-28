class Parent < ActiveRecord::Base
  include StreetAddressable

  default_scope :order => 'parents.created_at DESC'

  # Callbacks
  #----------------------------------------------------------------------------
  before_save :clean_phone_numbers

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
  def self.search(q, parent_params)
    scope = self.scoped
    phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")

    if phone.is_numeric?
      scope = scope.where("phone = ? OR mobile = ?", phone, phone)
    else
     scope = scope.where("email = ? OR email_2 = ? OR name like ?", q, q, "%#{q}%")
    end
    scope = scope.where(parent_params)
    scope
  end

  #----------------------------------------------------------------------------
  private

  def clean_phone_numbers
    self.phone  = self.phone.gsub(/\D/, "") unless self.phone.blank?
    self.mobile = self.mobile.gsub(/\D/, "") unless self.mobile.blank?
  end
end
