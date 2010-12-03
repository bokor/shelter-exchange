class Account < ActiveRecord::Base
  before_validation :downcase_subdomain
  after_save :add_owner
  after_create :notify_account_creation
  
  # Associations
  # authenticates_many :user_sessions, :find_options => { :limit => 1 }, :scope_cookies => true
  
  has_many :users, :uniq => true, :dependent => :destroy
  has_many :shelters, :dependent => :destroy
  # NOT SURE if I'm going to keep these or not.  SEEMS SLOWER TO ACCESS
  # has_many :animals, :through => :shelters
  # has_many :tasks, :through => :shelters
  # has_many :alerts, :through => :shelters
  # has_many :notes, :through => :shelters
  
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :shelters
   
  
  # Validations
  validates_presence_of :subdomain
  validates_format_of :subdomain, 
                      :with => /^[A-Za-z0-9-]+$/, 
                      :message => 'can only contain alphanumeric characters; A-Z, 0-9 or hyphen', 
                      :allow_blank => true
   
  validates_exclusion_of :subdomain, 
                         :in => %w( www support blog wiki billing help api authenticate launchpad forum admin user login logout signup register mail ftp pop smtp ssl sftp ),
                         :message => " <strong>{{value}}</strong> is reserved and unavailable."
   
  validates_uniqueness_of :subdomain, :case_sensitive => false
  
  # Scopes
   
  private
   
     def downcase_subdomain
       self.subdomain.downcase! if attribute_present?(:subdomain)
     end
   
     def add_owner
       if owner_id.blank?
         self.owner_id = self.users.first.id
         self.save!
       end
     end
     
     def notify_account_creation
       Notifier.new_account_notification(self,self.shelters.first,self.users.first).deliver
     end
end
