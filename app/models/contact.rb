class Contact < ActiveRecord::Base
  include StreetAddressable

  # Callbacks
  #----------------------------------------------------------------------------
  before_save :clean_phone_numbers

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter

  # Validations
  #----------------------------------------------------------------------------
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true,  :phone_format => true
  validates :mobile, :phone_format => true, :allow_blank => true
  validates :email, :presence => true, :email_format => true

  # Class Methods
  #----------------------------------------------------------------------------
  def self.search(q)
    scope = self.scoped
    phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")

    if phone.is_numeric?
      scope = scope.where("phone = ? OR mobile = ?", phone, phone)
    else
      scope = scope.where("email = ? OR first_name like ? OR last_name like ? OR (first_name + ' ' + last_name) like ?", q, "%#{q}%", "%#{q}%", "%#{q}%")
    end

    scope
  end

  #----------------------------------------------------------------------------
  private

  def clean_phone_numbers
    self.phone  = self.phone.gsub(/\D/, "") unless self.phone.blank?
    self.mobile = self.mobile.gsub(/\D/, "") unless self.mobile.blank?
  end
end

