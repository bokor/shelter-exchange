class Animal < ActiveRecord::Base
  include Statusable, Typeable, Uploadable

  default_scope :order => "animals.name ASC"

  # Constants
  #----------------------------------------------------------------------------
  SEX = %w[male female].freeze
  AGES = %w[baby young adult senior].freeze
  SIZES = {
    :S => "Small",
    :M => "Medium",
    :L => "Large",
    :XL => "X-Large"
  }.freeze

  # Callbacks
  #----------------------------------------------------------------------------
  after_validation :update_breed_names

  before_save :set_status_change_date,
              :parse_and_set_dates,
              :clean_description,
              :remove_secondary_breed,
              :remove_special_needs

  after_save :create_status_history!,
             :enqueue_integrations

  after_update :lint_facebook_url

  # Getters/Setters
  #----------------------------------------------------------------------------
  attr_accessor :status_history_reason, :status_history_contact_id, :status_history_date,
                :status_history_date_month, :status_history_date_day, :status_history_date_year

  attr_accessor :date_of_birth_month, :date_of_birth_day, :date_of_birth_year,
                :arrival_date_month, :arrival_date_day, :arrival_date_year,
                :euthanasia_date_month, :euthanasia_date_day, :euthanasia_date_year

  def status_history_date
    if self.status_history_date_month.blank? && self.status_history_date_day.blank? && self.status_history_date_year.blank?
      @status_history_date = Date.today
    end
  end

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :animal_type, :readonly => true
  belongs_to :animal_status, :readonly => true
  belongs_to :accommodation
  belongs_to :shelter

  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :tasks, :as => :taskable, :dependent => :destroy
  has_many :status_histories, :dependent => :destroy

  has_many :photos, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :photos, :limit => Photo::MAX_TOTAL,
                                         :allow_destroy => true,
                                         :reject_if => Proc.new { |a| a["image"].blank? if a["image_cache"].blank? }

  # Validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
  validates :animal_type_id, :presence => { :message => "needs to be selected" }
  validates :animal_status_id, :presence => { :message => "needs to be selected" }
  validate :primary_breed_against_db
  validate :secondary_breed_against_db
  validates :sex, :presence => true
  validates :age, :presence => {
    :if => Proc.new { |a| AnimalStatus::ACTIVE.include?(a.animal_status_id) },
    :message => "needs to be selected"
  }
  validates :size, :presence => {
    :if => Proc.new { |a| AnimalStatus::ACTIVE.include?(a.animal_status_id) },
    :message => "needs to be selected"
  }
  validates :microchip, :uniqueness => {
    :allow_blank => true,
    :scope => :shelter_id,
    :message => "already exists in your shelter. Please return to the main Animal page and search by this microchip number to locate this record."
  }
  validates :special_needs, :presence => { :if => :special_needs? }
  validates :video_url, :video_url_format => true, :allow_blank => true
  validates :status_history_date, :date_format => true
  validates :date_of_birth, :date_format => true
  validates :arrival_date, :date_format => true
  validates :euthanasia_date, :date_format => true

  # General Scopes
  #----------------------------------------------------------------------------
  scope :latest, lambda { |status, limit| includes(:shelter, :photos).send(status).reorder("status_change_date DESC").limit(limit) }
  scope :auto_complete, lambda { |q| includes(:animal_type, :animal_status).where("name LIKE ?", "%#{q}%") }

  # Class Methods
  #----------------------------------------------------------------------------
  def self.duplicate_from(parent_id)
    parent = self.find(parent_id)
    animal = self.new
    animal.attributes = parent.attributes.except(
      "id",
      "name",
      "microchip",
      "video_url",
      "special_needs",
      "has_special_needs",
      "created_at",
      "updated_at",
    )
    animal
  end
  #----------------------------------------------------------------------------

  # Dashboard - Recent Activity
  #----------------------------------------------------------------------------
  def self.recent_activity(limit=10)
    includes(:animal_type, :animal_status).reorder("animals.updated_at DESC").limit(limit)
  end
  #----------------------------------------------------------------------------

  # API
  #----------------------------------------------------------------------------
  def self.api_lookup(types, statuses)
    scope = self.scoped
    scope = scope.includes(:animal_type, :animal_status, :photos)
    scope = scope.where(:animal_type_id => types) unless types.blank?

    scope = if statuses.blank?
      scope.available_for_adoption
    else
      scope.where(:animal_status_id => statuses)
    end

    scope
  end

  def self.api_filter(filters={})
    scope = self.scoped
    scope = scope.includes(:animal_type, :animal_status, :photos)

    # Filter Animal Status
    if filters[:animal_status].blank?
      scope = scope.available_for_adoption
    else
      scope = scope.where(:animal_status_id => filters[:animal_status])
    end

    # Filter Animal Type
    unless filters[:animal_type].blank?
      scope = scope.where(:animal_type_id => filters[:animal_type])
    end

    # Filter Special Needs
    unless filters[:special_needs_only].blank? || !filters[:special_needs_only]
      scope = scope.where(:has_special_needs => true)
    end

    # Filter Breed
    unless filters[:breed].blank?
      scope = scope.where("animals.primary_breed = ? OR animals.secondary_breed = ?", filters[:breed], filters[:breed])
    end

    # Filter Sex
    unless filters[:sex].blank?
      scope = scope.where(:sex => filters[:sex].downcase)
    end

    # Filter Size
    unless filters[:size].blank?
      scope = scope.where(:size => filters[:size])
    end

    scope
  end
  #----------------------------------------------------------------------------

  # Maps and Community
  #----------------------------------------------------------------------------
  def self.community_animals(shelter_ids, filters={})
    scope = self.scoped
    scope = scope.includes(:animal_type, :animal_status, :shelter, :photos)
    scope = scope.where(:shelter_id => shelter_ids)

    # Fitler Euthanasia
    unless filters[:euthanasia_only].blank? || !filters[:euthanasia_only]
      scope = scope.joins(:shelter)
      scope = scope.where("shelters.is_kill_shelter = ?", true)
      scope = scope.where("animals.euthanasia_date < ?", Time.zone.today + 2.weeks)
    end

    # Filter Special Needs
    unless filters[:special_needs_only].blank? || !filters[:special_needs_only]
      scope = scope.where(:has_special_needs => true)
    end

    # Filter Animal Type
    unless filters[:animal_type].blank?
      scope = scope.where(:animal_type_id => filters[:animal_type])
    end

    # Filter Breed
    unless filters[:breed].blank?
      scope = scope.where("animals.primary_breed = ? OR animals.secondary_breed = ?", filters[:breed], filters[:breed])
    end

    # Filter Sex
    unless filters[:sex].blank?
      scope = scope.where(:sex => filters[:sex].downcase)
    end

    # Filter Size
    unless filters[:size].blank?
      scope = scope.where(:size => filters[:size])
    end

    # Filter Animal Status
    if filters[:animal_status].blank?
      scope = scope.active
    else
      scope = scope.where(:animal_status_id => filters[:animal_status])
    end

    if shelter_ids.is_a?(Array) && shelter_ids.any?
      scope.reorder("FIELD(shelter_id, #{shelter_ids.join(',')}), ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC")
    else
      scope.reorder("ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC")
    end
  end
  #----------------------------------------------------------------------------


  # Searching
  #----------------------------------------------------------------------------
  def self.search_and_filter(query, type_id, status_id, order_by)
    scope = self.scoped
    scope = scope.includes(:animal_type, :animal_status, :photos)

    # Filter by type
    scope = scope.where(:animal_type_id => type_id) unless type_id.blank?

    # Filter by status
    status_id = "active" if status_id.blank?
    scope = if status_id == "active" || status_id == "non_active"
      scope.send(status_id)
    elsif status_id == "active_and_non_active"
      scope.where(:animal_status_id => AnimalStatus::STATUSES.values)
    else
      scope.where(:animal_status_id => status_id)
    end

    # Search by query
    unless query.blank?
      query = query.strip.split.join("%")

      if query.is_numeric?
        scope = scope.where("animals.id = ? OR animals.microchip = ?", query, query)
      else
        scope = scope.where(
          "animals.name LIKE ? OR animals.description LIKE ? OR animals.microchip LIKE ? OR animals.primary_breed LIKE ? OR animals.secondary_breed LIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"
        )
      end
    end

    # Order by
    scope = scope.reorder(order_by) unless order_by.blank?
    scope
  end

  def self.admin_search_by_name(q)
    scope = self.scoped
    scope = scope.includes(:animal_type, :animal_status, :photos)
    if q.is_numeric?
      scope = scope.where("animals.id = ?", q)
    else
      scope = scope.where("animals.name LIKE ?", "%#{q}%")
    end

    scope
  end
  #----------------------------------------------------------------------------

  # Reporting
  #----------------------------------------------------------------------------
  scope :count_by_type, select("count(*) count, animal_types.name").joins(:animal_type).group(:animal_type_id).reorder("animal_types.name ASC")
  scope :count_by_status, select("count(*) count, animal_statuses.name").
                          joins(:animal_status).group(:animal_status_id).reorder("animal_statuses.name ASC")
  scope :current_month, where(:status_change_date => Time.zone.today.beginning_of_month..Time.zone.today.end_of_month)
  scope :year_to_date, where(:status_change_date => Time.zone.today.beginning_of_year..Time.zone.today.end_of_year)

  def self.type_by_month_year(month, year, shelter_id=nil, state=nil)
    start_date = (month.blank? || year.blank?) ? Time.zone.today : Date.parse("#{year}/#{month}/01")
    range = start_date.beginning_of_month..start_date.end_of_month

    animal_ids = if shelter_id
      StatusHistory.where(:shelter_id => shelter_id).by_month(range).collect(&:animal_id).uniq
    else
      StatusHistory.by_month(range).collect(&:animal_id).uniq
    end

    scope = self.scoped
    scope = scope.select("count(*) count, animal_types.name")
    scope = scope.joins(:animal_type)

    unless state.blank?
      scope = scope.joins(:shelter)
      scope = scope.where(:shelters => { :state => state })
    end

    scope = scope.where(:id => animal_ids)
    scope = scope.group(:animal_type_id)
    scope
  end

  def self.intake_totals_by_month(year, with_type=false)
    start_date = year.blank? ? Time.zone.now.beginning_of_year : Date.parse("#{year}/01/01").beginning_of_year
    end_date = year.blank? ? Time.zone.now.end_of_year : Date.parse("#{year}/01/01").end_of_year
    scope = self.scoped

    if with_type
      scope = scope.select("animal_types.name as type").joins(:animal_type).group(:animal_type_id)
    else
      scope = scope.select("'Total' as type")
    end

    start_date.month.upto(end_date.month) do |month|
      scope = scope.select("COUNT(CASE WHEN animals.created_at BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
      start_date = start_date.next_month
    end
    scope = scope.reorder(nil).limit(nil)
    scope
  end
  #----------------------------------------------------------------------------

  # Instance Methods
  #----------------------------------------------------------------------------
  def full_breed
    if mix_breed?
      self.secondary_breed.blank? ? self.primary_breed + " Mix" : self.primary_breed + " & " + self.secondary_breed + " Mix"
    else
      self.primary_breed
    end
  end

  def special_needs?
    self.has_special_needs
  end

  def mix_breed?
    self.is_mix_breed
  end

  def sterilized?
    self.is_sterilized
  end


  #-----------------------------------------------------------------------------
  private

  def is_kill_shelter?
    @shelter ||= self.shelter.kill_shelter?
  end

  def update_breed_names
    if self.animal_type_id
      if self.primary_breed
        breed_lookup = Breed.valid_for_animal(self.primary_breed.strip, self.animal_type_id).first
        self.primary_breed = breed_lookup.name unless breed_lookup.blank?
      end

      if self.secondary_breed
        breed_lookup = Breed.valid_for_animal(self.secondary_breed.strip, self.animal_type_id).first
        self.secondary_breed = breed_lookup.name unless breed_lookup.blank?
      end
    end
  end

  def primary_breed_against_db
    unless self.animal_type_id.blank?
      if self.primary_breed.blank?
        self.errors.add_on_blank(:primary_breed)
      else
        unless self.other?  # Bypass Type = Other
          if Breed.valid_for_animal(self.primary_breed, self.animal_type_id).blank?
            self.errors.add(:primary_breed, "must contain a valid breed name")
          end
        end
      end
    end
  end

  def secondary_breed_against_db
    unless self.secondary_breed.blank? || self.other? # Bypass Type = Other
      if self.mix_breed? && Breed.valid_for_animal(self.secondary_breed, self.animal_type_id).blank?
        self.errors.add(:secondary_breed, "must contain a valid breed name")
      end
    end
  end

  def set_status_change_date
    if self.new_record? || self.animal_status_id_changed?
      parsed_date = Date.parse("#{self.status_history_date_year}/#{self.status_history_date_month}/#{self.status_history_date_day}") rescue Time.zone.today
      self.status_change_date = parsed_date
    end
  end

  def parse_and_set_dates
    unless errors.has_key?(:date_of_birth)
      self.date_of_birth = Date.parse("#{self.date_of_birth_year}/#{self.date_of_birth_month}/#{self.date_of_birth_day}") rescue nil
    end

    unless errors.has_key?(:arrival_date)
      self.arrival_date = Date.parse("#{self.arrival_date_year}/#{self.arrival_date_month}/#{self.arrival_date_day}") rescue nil
    end

    unless errors.has_key?(:euthanasia_date)
      self.euthanasia_date = Date.parse("#{self.euthanasia_date_year}/#{self.euthanasia_date_month}/#{self.euthanasia_date_day}") rescue nil
    end
  end

  def create_status_history!
    if self.new_record? || self.animal_status_id_changed? || self.shelter_id_changed?
      date = Date.parse("#{self.status_history_date_year}/#{self.status_history_date_month}/#{self.status_history_date_day}") rescue nil
      StatusHistory.create_with(self.shelter_id, self.id, self.animal_status_id, date, @status_history_reason, @status_history_contact_id)
    end
  end

  def clean_description
    # Remove Microsoft Extra Smart Formatting
    unless self.description.blank?
      self.description.gsub!(/[\u201C\u201D\u201E\u201F\u2033\u2036]/, '"')
      self.description.gsub!(/[\u2018\u2019\u201A\u201B\u2032\u2035\uFFFD]/, "'")
      self.description.gsub!(/[\u2013\u2014]/, "-")
      self.description.gsub!(/\u02C6/, "^")
      self.description.gsub!(/\u2039/, "<")
      self.description.gsub!(/\u203A/, ">")
      self.description.gsub!(/\u2013/, "-")
      self.description.gsub!(/\u2014/, "--")
      self.description.gsub!(/\u2026/, "...")
      self.description.gsub!(/\u00A9/, "&copy;")
      self.description.gsub!(/\u00AE/, "&reg;")
      self.description.gsub!(/\u2122/, "&trade;")
      self.description.gsub!(/\u00BC/, "&frac14;")
      self.description.gsub!(/\u00BD/, "&frac12;")
      self.description.gsub!(/\u00BE/, "&frac34;")
      self.description.gsub!(/[\u02DC\u00A0]/, " ")
      self.description.strip!
    end
  end

  def remove_secondary_breed
    self.secondary_breed = nil unless self.mix_breed?
  end

  def remove_special_needs
    self.special_needs = nil unless self.special_needs?
  end

  def lint_facebook_url
    if self.animal_status_id_changed? && Rails.env.production?
      Delayed::Job.enqueue(FacebookLinterJob.new(self.id))
    end
  end

  def enqueue_integrations
    if [self.animal_status_id_was, self.animal_status_id].any? { |status| AnimalStatus::AVAILABLE.include?(status) }
      Integration.where(:shelter_id => self.shelter_id).each do |integration|
        case integration.to_sym
        when :petfinder
          Delayed::Job.enqueue(PetfinderJob.new(self.shelter_id))
        when :adopt_a_pet
          Delayed::Job.enqueue(AdoptAPetJob.new(self.shelter_id))
        end
      end
    end
  end
end

