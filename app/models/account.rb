class Account < ActiveRecord::Base
  include Document
  
  # Callbacks
  #----------------------------------------------------------------------------
  before_validation :downcase_subdomain, :assign_owner_role
      
  # Associations
  #----------------------------------------------------------------------------
  has_many :users, :uniq => true, :dependent => :destroy
  has_many :shelters, :dependent => :destroy

  # Nested Attributes
  #----------------------------------------------------------------------------  
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :shelters
  
  # Validations
  #----------------------------------------------------------------------------
  validates :subdomain, :presence => true, :uniqueness => true, :subdomain_format => true, :subdomain_exclusion => true

  # Class Methods
  #----------------------------------------------------------------------------

           
  # Instance Methods
  #----------------------------------------------------------------------------
  def approved?
    !self.blocked
  end
  
  def blocked?
    self.blocked
  end
  
  private

    def downcase_subdomain
      self.subdomain.downcase! if attribute_present?(:subdomain)
    end
   
    def assign_owner_role
      self.users.first.role = User::OWNER
    end
    
end