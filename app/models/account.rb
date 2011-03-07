class Account < ActiveRecord::Base
  before_validation :downcase_subdomain, :assign_owner_role
  # after_create :new_account_notification
  after_save :new_account_notification
  
  # Associations
  has_many :users, :uniq => true, :dependent => :destroy
  has_many :shelters, :dependent => :destroy
  
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :shelters
  
  # Validations
  validates :subdomain, :presence => true,
                        :format => { :with => SUBDOMAIN_FORMAT, :message => "can only contain alphanumeric characters; A-Z, 0-9 or hyphen" },
                        :exclusion => { :in => RESERVED_SUBDOMAINS, :message => "is reserved and unavailable."},
                        :uniqueness => true
   
  private
   
    def downcase_subdomain
      self.subdomain.downcase! if attribute_present?(:subdomain)
    end
     
    def assign_owner_role
      self.users.first.role = User::OWNER
    end
     
    def new_account_notification
      Notifier.new_account_notification(self,self.shelters.first,self.users.first).deliver
    end
    
end


# Moved into 1 statement
# validates_presence_of :subdomain
# validates_format_of :subdomain, 
#                     :with => SUBDOMAIN_FORMAT, 
#                     :message => 'can only contain alphanumeric characters; A-Z, 0-9 or hyphen'
 
# validates_exclusion_of :subdomain, 
#                        :in => RESERVED_SUBDOMAINS,
#                        :message => '<strong>#{self.subdomain}</strong> is reserved and unavailable.'
 
# validates_uniqueness_of :subdomain, :case_sensitive => false

  # after_save :add_owner
#    OLD WAY WITH OWNER_ID
# def add_owner
#   if owner_id.blank?
#     self.owner_id = self.users.first.id
#     self.users.first.role = "owner"
#     self.save!
#   end
# end

# NOT SURE if I'm going to keep these or not.  SEEMS SLOWER TO ACCESS
# has_many :animals, :through => :shelters
# has_many :tasks, :through => :shelters
# has_many :alerts, :through => :shelters
# has_many :notes, :through => :shelters
