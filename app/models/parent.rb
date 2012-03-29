class Parent < ActiveRecord::Base
  include StreetAddressable, Phoneable
  
  default_scope :order => 'created_at DESC' #, :limit => 25
  
  # Associations
  #----------------------------------------------------------------------------
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  
  # Validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
  validates :phone, :presence => true,  :uniqueness => true, :phone_format => true
  validates :mobile, :uniqueness => true, :phone_format => true, :allow_blank => true
  validates :email, :uniqueness => {:message => "There is an existing Parent associated with these details, please use the 'Look up' to locate the record."}, 
                    :allow_blank => true, :email_format => true
  validates :email_2, :uniqueness => {:message => "There is an existing Parent associated with these details, please use the 'Look up' to locate the record."}, 
                      :allow_blank => true, :email_format => true
                    
  # Scopes
  #----------------------------------------------------------------------------
  def self.search(q)
    phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")
    where("phone = '#{phone}' OR mobile = '#{phone}' OR email = '#{q}' OR email_2 = '#{q}'").limit(10)
  end
        
end