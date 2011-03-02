class Parent < ActiveRecord::Base
  before_validation :format_phone_numbers
  default_scope :order => 'created_at DESC', :limit => 25
  
  # Associations
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  
  # Validations
  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates :home_phone, :presence => true, 
                         :uniqueness => true
  validates :mobile_phone, :uniqueness => true
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => EMAIL_FORMAT}
                    
  # Scopes
  scope :search, lambda { |q| phone = q.gsub(/[^0-9]/, "") 
                              phone = q if phone.blank?
                              where("LOWER(name) LIKE LOWER('%#{q}%') OR LOWER(street) LIKE LOWER('%#{q}%') 
                                     OR LOWER(home_phone) LIKE LOWER('%#{phone}%') OR LOWER(mobile_phone) LIKE LOWER('%#{phone}%') 
                                     OR LOWER(email) LIKE LOWER('%#{q}%')") }
  
  private 
    def format_phone_numbers
      self.home_phone = self.home_phone.gsub(/[^0-9]/, "") unless self.home_phone.blank?
      self.mobile_phone = self.mobile_phone.gsub(/[^0-9]/, "")  unless self.mobile_phone.blank?
    end
    
end
