class Animal < ActiveRecord::Base
  default_scope :order => 'animals.created_at DESC', :limit => 250
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
                            :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
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
  
  def full_breed
    if self.is_mix_breed
      self.secondary_breed.blank? ? self.primary_breed << " Mix" : self.primary_breed << " & " << self.secondary_breed << " Mix"
	  else
	    self.primary_breed
	  end
  end
  
  def as_json(options = {})
    json_format(version = options[:version])
  end

  def to_xml(options = {})
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => 2, :dasherize => false, :skip_types => true)
    xml.instruct!
    xml_format(xml, version = options[:version])
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
      if self.new_record? or self.animal_status_id_changed?
        update_status_change_date
      end
    end
    
    def destroy_photo?
      self.photo.clear if @photo_delete == "1"
    end
    
    def json_format(version)
      if version == :v1
        { :animal => {
            :id => id,
            :name => name,
            :type => animal_type.name,
            :status => animal_status.name,
            :breed => full_breed,
            :age => age,
            :color => color,
            :description => description,
            :is_sterilized => is_sterilized,
            :weight => weight,
            :sex => sex.to_s.humanize,
            :photo => {
              :thumbnail => photo.url(:thumbnail),
              :small => photo.url(:small),
              :large => photo.url(:large)
            }
          }
        }
      end
    end
    
    def xml_format(xml, version)
      if version == :v1
        xml.animal do
          xml.id   id
          xml.name   name
          xml.type   animal_type.name
          xml.status   animal_status.name
          xml.breed   full_breed
          xml.age   age
          xml.color   color
          xml.description   description
          xml.is_sterilized   is_sterilized
          xml.weight   weight
          xml.sex   sex.to_s.humanize
          xml.photo do 
            xml.thumbnail   photo.url(:thumbnail)
            xml.small   photo.url(:small)
            xml.large   photo.url(:large)
          end
        end
      end
    end
end