class Contact < ActiveRecord::Base
  include Geocodeable, Uploadable

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
  validates :first_name, :presence => true, :unless => lambda {|contact| contact.last_name.present? }
  validates :last_name, :presence => true, :unless => lambda {|contact| contact.first_name.present? }

  # Scopes - Dashboard Only - Recent Activity
  #----------------------------------------------------------------------------
  def self.recent_activity(limit=10)
    reorder("contacts.updated_at DESC").limit(limit)
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.search(q)
    scope = self.scoped

    unless q.blank?
      phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")
      valid_phone = phone.is_numeric?
      valid_email = (q =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)

      if valid_phone
        scope = scope.where("contacts.phone = ? OR contacts.mobile = ?", phone, phone)
      elsif valid_email
        scope = scope.where(:email => q)
      else
        q.split(" ").each do |word|
          scope = scope.where(
            "contacts.first_name LIKE ? OR contacts.last_name LIKE ? OR contacts.company_name LIKE ?",
            "%#{word}%", "%#{word}%", "%#{word}%")
        end
      end
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

