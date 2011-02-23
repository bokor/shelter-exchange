class Animal < ActiveRecord::Base
  default_scope :order => 'animals.created_at DESC', :limit => 250
  before_create :update_status_change_date
  before_save :check_status_change?, :destroy_photo?
  
  Rails.env.development? ? PER_PAGE = 4 : PER_PAGE = 25
  
  # Associations
  belongs_to :animal_type, :readonly => true
  belongs_to :animal_status, :readonly => true
  belongs_to :accommodation
  belongs_to :shelter
  
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :alerts, :as => :alertable, :dependent => :destroy
  has_many :tasks, :as => :taskable, :dependent => :destroy
  
  has_attached_file :photo, :whiny => false, :default_url => "/images/default_:style_photo.jpg", 
                            :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
                            # :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                            :styles => { :small => ["250x150>", :jpg],
                                         :medium => ["350x250>", :jpg],
                                         :large => ["500x400>", :jpg], 
                                         :thumb => ["100x75#", :jpg] } 

  # Validations
  validates_presence_of :name
  validates_presence_of :animal_type_id, :message => 'needs to be selected'
  validates_presence_of :animal_status_id, :message => 'needs to be selected'
  
  # Custom Validations
  validate :primary_breed, :presence => true, :if => :primary_breed_exists?
  validate :secondary_breed, :presence => true, :if => :secondary_breed_exists?
  validate :arrival_date, :presence => true, :if => :arrival_date_required?
  validate :euthanasia_scheduled, :presence => true, :if => :euthanasia_scheduled_required?
  validate :hold_time, :presence => true, :if => :hold_time_required?
  
  validates_attachment_size :photo, :less_than => 1.megabytes, :message => 'needs to be 1 MB or smaller'
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => 'needs to be a JPG, PNG, or GIF file'


  
  
  # Scopes
  scope :auto_complete, lambda { |q| includes(:animal_type, :animal_status).where("LOWER(name) LIKE LOWER('%#{q}%')") }
  scope :full_search, lambda { |q| includes(:animal_type, :animal_status).where("LOWER(id) LIKE LOWER('%#{q}%') OR LOWER(name) LIKE LOWER('%#{q}%') OR LOWER(description) LIKE LOWER('%#{q}%')
                                                                                OR LOWER(chip_id) LIKE LOWER('%#{q}%') OR LOWER(color) LIKE LOWER('%#{q}%')
                                                                                OR LOWER(age) LIKE LOWER('%#{q}%') OR LOWER(weight) LIKE LOWER('%#{q}%')
                                                                                OR LOWER(primary_breed) LIKE LOWER('%#{q}%') OR LOWER(secondary_breed) LIKE LOWER('%#{q}%')") }
  scope :search_by_name, lambda { |q| includes(:animal_type, :animal_status).where("LOWER(id) LIKE LOWER('%#{q}%') OR LOWER(name) LIKE LOWER('%#{q}%')") }                                              
  
  scope :active, where(:animal_status_id => [1,4,5,6,7,8])
  scope :non_active, where(:animal_status_id => [2,3,9,10,11])
  scope :available_for_adoption, where(:animal_status_id => 1)
  scope :adoptions, where(:animal_status_id => 2)
  scope :euthanized, where(:animal_status_id => 11)

  # Scopes - Reporting
  scope :count_by_type, select('count(*) count, animal_types.name').joins(:animal_type).group(:animal_type_id) 
  scope :count_by_status, select("count(*) count, animal_statuses.name").joins(:animal_status).group(:animal_status_id)
  scope :current_month, where(:status_change_date => Date.today.beginning_of_month..Date.today.end_of_month)
  scope :year_to_date, where(:status_change_date => Date.today.beginning_of_year..Date.today.end_of_year) 
  
  # FOR REFACTORING
  # scope :adoption_monthly_total_by_type, lambda { |year| totals_by_month(year, :status_change_date).adoptions }
  
  def self.totals_by_month(year, date_type, with_type=false)
    start_date = year.blank? ? Date.today.beginning_of_year : Date.parse("#{year}0101").beginning_of_year
    end_date = year.blank? ? Date.today.end_of_year : Date.parse("#{year}0101").end_of_year
    composed_scope = self.scoped
    
    if with_type
      composed_scope = composed_scope.select("animal_types.name as type").joins(:animal_type).group(:animal_type_id)
    else
      composed_scope = composed_scope.select("'Total' as type")
    end
    
    start_date.month.upto(end_date.month) do |month|
      composed_scope = composed_scope.select("COUNT(CASE WHEN animals.#{date_type.to_s} BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::ABBR_MONTHNAMES[month].downcase}")
      start_date = start_date.next_month
    end

    composed_scope
  end
  
  def photo_delete
    @photo_delete ||= "0"
  end

  def photo_delete=(value)
    @photo_delete = value
  end
                                                 
  private

    def primary_breed_exists?
      if self.primary_breed && self.animal_type_id
        if Breed.valid_for_animal(primary_breed, animal_type_id).blank?
          errors.add(:primary_breed, "must contain a valid breed from the list")
        end
      end
    end

    def secondary_breed_exists?
      if self.is_mix_breed && !self.secondary_breed.blank?
        if Breed.valid_for_animal(secondary_breed, animal_type_id).blank?
          errors.add(:secondary_breed, "must contain a valid breed from the list")
        end
      end
    end
    
    def is_kill_shelter?
      Shelter.find_by_id(self.shelter_id).is_kill_shelter
    end
    
    def arrival_date_required?
      if is_kill_shelter? && self.arrival_date.blank?
        errors.add(:arrival_date, "must be selected")
      end
    end

    def euthanasia_scheduled_required?
      if is_kill_shelter? && self.euthanasia_scheduled.blank?
        errors.add(:euthanasia_scheduled, "must be selected")
      end
    end
        
    def hold_time_required?
      if is_kill_shelter? && self.hold_time.blank?
        errors.add(:hold_time, "must be entered")
      end
    end

    def update_status_change_date
      self.status_change_date = Date.today
    end
    
    def check_status_change?
      if self.animal_status_id_changed?
        update_status_change_date
      end
    end
    
    def destroy_photo?
      self.photo.clear if @photo_delete == "1"
    end
    
end


# has_many :parents, :through => :placements
# has_many :breeds, :readonly => true

# scope :total_available_for_adoption, joins(:animal_status).where("animal_statuses.name = 'Available for Adoption'") #id-1
# scope :total_adoptions, joins(:animal_status).where("animal_statuses.name = 'Adopted'") #id-2
# scope :total_euthanized, joins(:animal_status).where("animal_statuses.name = 'Euthanized'")#id-11

# def clear_photo
#   self.photo.queued_for_write.clear if !photo.dirty?
#   # self.photo = nil
# end

# def delete_photo=(value)
#   @delete_photo = !value.to_i.zero?
# end
# 
# def delete_photo
#   !!@delete_photo
# end
# alias_method :delete_photo?, :delete_photo

# def test_save
#   if @delete_avatar == 1.to_s 
#     self.avatar = nil 
#     self.avatar.queued_for_write.clear
#   end
# end


#  OR
# validates_presence_of :animal_type, :message => 'needs to be selected'
# validates_presence_of :animal_status, :message => 'needs to be selected'

# validates_attachment_presence :photo

# has_attached_file :photo, :styles => { :small => "150x150>" },
#                   :url  => "/assets/products/:id/:style/:basename.:extension",
#                   :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"



# STATUS = { "available_for_adoption" => "Available for Adoption", 
#            "adopted" => "Adopted", 
#            "foster_care" => "Foster Care",
#            "new_intake" => "New Intake", 
#            "in_transit" => "In Transit",
#            "on_hold_behavioral" => "On Hold - Behavioral",
#            "on_hold_medical" => "On Hold - Medical",
#            "on_hold_stray_intake" => "On Hold - Stray Intake",
#            "deceased" => "Deceased",
#            "euthanized" => "Euthanized" }


# d1 = Date.parse("20070617") # => Sun, 17 Jun 2007
# d2 = Date.parse("20090529") #=> Fri, 29 May 2009
# eom = d1.end_of_month #=> Sat, 30 Jun 2007
# mth_ends = [eom] #=> [Sat, 30 Jun 2007]
# while eom < d2
#   eom = eom.advance(:days => 1).end_of_month
#   mth_ends << eom
# end
# yrs = mth_ends.group_by{|me| me.year}
# 
# d1.year.upto(d2.year) do |yr|
#   puts "#{yrs[yr].min}, #{yrs[yr].max}"
# end
# 2007-06-30, 2007-12-31
# 2008-01-31, 2008-12-31
# 2009-01-31, 2009-05-31


# scope :total_adoptions_by_type_and_month, select("animal_types.name as type").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-01-01' AND '2011-01-31' THEN 1 END) AS jan").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-02-01' AND '2011-02-28' THEN 1 END) AS feb").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-03-01' AND '2011-03-31' THEN 1 END) AS mar").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-04-01' AND '2011-04-30' THEN 1 END) AS apr").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-05-01' AND '2011-05-31' THEN 1 END) AS may").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-06-01' AND '2011-06-30' THEN 1 END) AS jun").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-07-01' AND '2011-07-31' THEN 1 END) AS jul").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-08-01' AND '2011-08-31' THEN 1 END) AS aug").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-09-01' AND '2011-09-30' THEN 1 END) AS sept").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-10-01' AND '2011-10-31' THEN 1 END) AS oct").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-11-01' AND '2011-11-30' THEN 1 END) AS nov").
#                                    select("COUNT(CASE WHEN status_change_date BETWEEN '2011-12-01' AND '2011-12-31' THEN 1 END) AS dec").
#                                    where(:animal_status_id => 2).joins(:animal_type).group(:animal_type_id) 
# Original Query
#
# SELECT animal_types.name as Type,
#        COUNT(CASE WHEN status_change_date BETWEEN '2011-01-01' AND '2011-01-31' THEN 1 END) AS jan,       
#          COUNT(CASE WHEN status_change_date BETWEEN '2011-02-01' AND '2011-02-28' THEN 1 END) AS feb
#     FROM animals
#   INNER JOIN "animal_types" ON "animal_types"."id" = "animals"."animal_type_id" 
#     WHERE ("animals".shelter_id = 3) 
#       AND "animals"."animal_status_id" = 2
#   GROUP BY animal_types.name

# def self.total_adoptions_by_type_and_month
#   start_date = Date.today.beginning_of_year
#   end_date = Date.today.end_of_year
#   composed_scope = self.scoped
#   composed_scope = composed_scope.select("animal_types.name as type")
#   start_date.month.upto(end_date.month) do |month|
#     composed_scope = composed_scope.select("COUNT(CASE WHEN status_change_date BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::ABBR_MONTHNAMES[month].downcase}")
#     start_date = start_date.next_month
#   end
#   composed_scope = composed_scope.where(:animal_status_id => 2).joins(:animal_type).group(:animal_type_id) 
#   composed_scope
# end
# 
# def self.total_adoptions_by_month
#   start_date = Date.today.beginning_of_year
#   end_date = Date.today.end_of_year
#   composed_scope = self.scoped
#   start_date.month.upto(end_date.month) do |month|
#     composed_scope = composed_scope.select("COUNT(CASE WHEN status_change_date BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::ABBR_MONTHNAMES[month].downcase}")
#     start_date = start_date.next_month
#   end
#   composed_scope = composed_scope.where(:animal_status_id => 2)
#   composed_scope
# end
   
