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
  def self.search_and_filter(query, by_last_name, by_role, order_by)
    scope = self.scoped

    # Filter by last name
    scope = scope.where("contacts.last_name like ?", "#{by_last_name}%") unless by_last_name.blank?

    # Filter by role
    scope = scope.where(by_role.to_sym => true) unless by_role.blank?

    # Search by query
    unless query.blank?
      phone = query.gsub(/\D/, "").blank? ? query : query.gsub(/\D/, "")

      if phone.is_numeric? # Valid Phone
        scope = scope.where("contacts.phone = ? OR contacts.mobile = ?", phone, phone)
      else
        query.split(" ").each do |word|
          scope = scope.where(
            "contacts.first_name LIKE ? OR contacts.last_name LIKE ? OR contacts.company_name LIKE ? OR contacts.email LIKE ? OR contacts.city LIKE ?",
            "%#{word}%", "%#{word}%", "%#{word}%", "%#{word}%", "%#{word}%")
        end
      end
    end

    # Order by
    scope = scope.reorder(order_by) unless order_by.blank?
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

