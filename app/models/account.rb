class Account < ActiveRecord::Base
  
  # Callbacks
  #----------------------------------------------------------------------------
  before_validation :downcase_subdomain, :assign_owner_role
  
  # Associations
  #----------------------------------------------------------------------------
  has_many :users, :uniq => true, :dependent => :destroy
  has_many :shelters, :dependent => :destroy
  
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :shelters
  
  # Validations
  #----------------------------------------------------------------------------
  validates :subdomain, :presence => true,
                        :uniqueness => true,
                        :format => { :with => SUBDOMAIN_FORMAT, :message => "can only contain alphanumeric characters; A-Z, 0-9 or hyphen" },
                        :exclusion => { :in => RESERVED_SUBDOMAINS, :message => "is reserved and unavailable."}
           

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