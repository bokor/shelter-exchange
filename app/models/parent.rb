class Parent < ActiveRecord::Base
  default_scope :order => 'created_at DESC' #, :limit => 25

  # Callbacks
  #----------------------------------------------------------------------------
  before_validation :format_phone_numbers
  
  # Associations
  #----------------------------------------------------------------------------
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  
  # Validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
  validates :home_phone, :presence => true, :uniqueness => true
  validates :mobile_phone, :uniqueness => true, :allow_blank => true
  validates :email, :uniqueness => true, 
                    :allow_blank => true,
                    :format => {:with => EMAIL_FORMAT, :message => "format is incorrect"}
  validates :secondary_email, :uniqueness => true, 
                              :allow_blank => true,
                              :format => {:with => EMAIL_FORMAT, :message => "format is incorrect"}
                    
  validate :address_valid?
                    
  # Scopes
  #----------------------------------------------------------------------------
  def self.search(q)
    phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")
    where("home_phone = '#{phone}' OR mobile_phone = '#{phone}' OR email = '#{q}' OR secondary_email = '#{q}'").limit(10)
  end

  
  private 
  
    def format_phone_numbers
      self.home_phone.gsub(/\D/, "") unless self.home_phone.blank?
      self.mobile_phone.gsub(/\D/, "") unless self.mobile_phone.blank?
    end
    
    def address_valid?
      errors.add(:address, "Street, City, State and Zip code are all required") if self.street.blank? or self.city.blank? or self.state.blank? or self.zip_code.blank?
    end
        
end