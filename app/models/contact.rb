class Contact < ActiveRecord::Base
  include StreetAddressable, Geocodeable, Uploadable

  default_scope :order => 'contacts.last_name ASC, contacts.first_name ASC'

  # Constants
  #----------------------------------------------------------------------------
  ROLES = [
    "adopter",
    "foster",
    "volunteer",
    "transporter",
    "donor",
    "staff",
    "veterinarian"
  ].freeze

  # Callbacks
  #----------------------------------------------------------------------------
  before_save :clean_phone_numbers

  # Associations
  #----------------------------------------------------------------------------
  mount_uploader :photo, ContactPhotoUploader

  belongs_to :shelter

  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :status_histories, :readonly => true

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

  def self.filter_by_last_name_role(by_last_name, by_role)
    scope = self.scoped
    scope = scope.where("contacts.last_name like ?", "#{by_last_name}%") unless by_last_name.blank?
    scope = scope.where(by_role.to_sym => true) unless by_role.blank?
    scope
  end

  # Instance Methods
  #----------------------------------------------------------------------------
  def name
    "#{self.first_name} #{self.last_name}"
  end

  #----------------------------------------------------------------------------
  private

  def clean_phone_numbers
    self.phone  = self.phone.gsub(/\D/, "") unless self.phone.blank?
    self.mobile = self.mobile.gsub(/\D/, "") unless self.mobile.blank?
  end
end

