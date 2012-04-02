class Parent < ActiveRecord::Base
  include StreetAddressable
  
  default_scope :order => 'created_at DESC' #, :limit => 25
  
  # Callbacks
  #----------------------------------------------------------------------------
  before_save :clean_phone_numbers
  
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
    where("phone = ? OR mobile = ? OR email = ? OR email_2 = ?", phone, phone, q, q).limit(10)
  end
  
  private
  
    def clean_phone_numbers
      [:phone, :mobile].each do |type|
        # self.send("#{type}=", self.send(type).gsub(/\D/, "")) if self.respond_to?(type) and self.send(type).present?
        self[type] = self.send(type).gsub(/\D/, "") if self.respond_to?(type) and self.send(type).present?
      end
    end
        
end