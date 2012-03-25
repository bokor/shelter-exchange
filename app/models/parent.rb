class Parent < ActiveRecord::Base
  include StreetAddressable
  
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
  validates :home_phone, :presence => true,  :uniqueness => true
  validates :mobile_phone, :uniqueness => true,  :allow_blank => true
  validates :email, :uniqueness => {:message => "There is an existing Parent associated with these details, please use the 'Look up' to locate the record."}, 
                    :allow_blank => true, :email_format => true
  validates :email_2, :uniqueness => {:message => "There is an existing Parent associated with these details, please use the 'Look up' to locate the record."}, 
                      :allow_blank => true, :email_format => true
                    
  # Scopes
  #----------------------------------------------------------------------------
  def self.search(q)
    phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")
    where("home_phone = '#{phone}' OR mobile_phone = '#{phone}' OR email = '#{q}' OR email_2 = '#{q}'").limit(10)
  end

  private 
  
    def format_phone_numbers
      self.home_phone.gsub!(/\D/, "") unless self.home_phone.blank?
      self.mobile_phone.gsub!(/\D/, "") unless self.mobile_phone.blank?
    end
        
end