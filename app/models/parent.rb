class Parent < ActiveRecord::Base
  default_scope :order => 'created_at DESC', :limit => 25
  before_validation :format_phone_numbers
  
  # Associations
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  
  # Validations
  validates :name, :street, :city, :state, :zip_code, :presence => true
  validates :home_phone, :presence => true, :uniqueness => true
  validates :mobile_phone, :uniqueness => true, :allow_blank => true
  validates :email, :uniqueness => true, :allow_blank => true,
                    :length => {:minimum => 3, :maximum => 254}, 
                    :format => {:with => EMAIL_FORMAT, :message => "format is incorrect"}
                    
                    
                    
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
