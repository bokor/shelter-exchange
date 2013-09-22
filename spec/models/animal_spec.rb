require "spec_helper"

#
#   # General Scopes
#   #----------------------------------------------------------------------------
#   scope :latest, lambda { |status, limit| includes(:shelter, :photos).send(status).order("status_change_date DESC").limit(limit) }
#   scope :auto_complete, lambda { |q| includes(:animal_type, :animal_status).where("name LIKE ?", "%#{q}%") }
#   scope :search, lambda { |q|
#     includes(:animal_type, :animal_status, :photos).
#     where("animals.id LIKE ? OR animals.name LIKE ? OR animals.description LIKE ? OR
#            animals.microchip LIKE ? OR animals.color LIKE ? OR animals.weight LIKE ? OR
#            animals.primary_breed LIKE ? OR animals.secondary_breed LIKE ?",
#            "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%")
#   }
#
#   # Dashboard - Recent Activity
#   #----------------------------------------------------------------------------
#   def self.recent_activity(limit=10)
#     includes(:animal_type, :animal_status).reorder("animals.updated_at DESC").limit(limit)
#   end
#   #----------------------------------------------------------------------------
#
#   # API
#   #----------------------------------------------------------------------------
#   def self.api_lookup(types, statuses)
#     scope = self.scoped
#     scope = scope.includes(:animal_type, :animal_status, :photos)
#     scope = (statuses.blank? ? scope.available : scope.where(:animal_status_id => statuses))
#     scope = scope.where(:animal_type_id => types) unless types.blank?
#     scope = scope.reorder("ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC")
#     scope
#   end
#   #----------------------------------------------------------------------------
#
#   # Maps and Community
#   #----------------------------------------------------------------------------
#   def self.community_animals(shelter_ids, filters={})
#     scope = self.scoped
#     scope = scope.includes(:animal_type, :animal_status, :shelter, :photos)
#     scope = scope.where(:shelter_id => shelter_ids)
#     # Fitler Euthanasia
#     scope = scope.joins(:shelter).where("shelters.is_kill_shelter = ?", true).where("animals.euthanasia_date < ?", Date.today + 2.weeks) unless filters[:euthanasia_only].blank? or !filters[:euthanasia_only]
#     # Filter Special Needs
#     scope = scope.where(:has_special_needs => true) unless filters[:special_needs_only].blank? or !filters[:special_needs_only]
#     # Filter Animal Type
#     scope = scope.where(:animal_type_id => filters[:animal_type]) unless filters[:animal_type].blank?
#     # Filter Breed
#     scope = scope.where("animals.primary_breed = ? OR animals.secondary_breed = ?", filters[:breed], breed) unless filters[:breed].blank?
#     # Filter Sex
#     scope = scope.where(:sex => filters[:sex].downcase) unless filters[:sex].blank?
#     # Filter Animal Status
#     scope = scope.where(:animal_status_id => filters[:animal_status]) unless filters[:animal_status].blank?
#     scope = scope.active unless filters[:animal_status].present?
#
#     if shelter_ids.is_a?(Array) && shelter_ids.any?
#       scope.reorder("FIELD(shelter_id, #{shelter_ids.join(',')}), ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC")
#     else
#       scope.reorder("ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC")
#     end
#   end
#   #----------------------------------------------------------------------------
#
#
#   # Searching
#   #----------------------------------------------------------------------------
#   def self.search_by_name(q)
#     scope = self.scoped
#     scope = scope.includes(:animal_type, :animal_status, :photos)
#     if q.is_numeric?
#       scope = scope.where(:"animals.id" => q)
#     else
#       scope = scope.where("animals.name LIKE ?", "%#{q}%")
#     end
#
#     scope
#   end
#
#   def self.filter_by_type_status(type, status)
#     scope = self.scoped
#     scope = scope.includes(:animal_type, :animal_status, :photos)
#     scope = scope.where(:animal_type_id => type) unless type.blank?
#     unless status.blank?
#       scope = (status == "active" or status == "non_active") ? scope.send(status) : scope.where(:animal_status_id => status)
#     end
#
#     scope
#   end
#   #----------------------------------------------------------------------------
#
#   # Reporting
#   #----------------------------------------------------------------------------
#   scope :count_by_type, select("count(*) count, animal_types.name").joins(:animal_type).group(:animal_type_id)
#   scope :count_by_status, select("count(*) count, animal_statuses.name").joins(:animal_status).group(:animal_status_id)
#   scope :current_month, where(:status_change_date => Date.today.beginning_of_month..Date.today.end_of_month)
#   scope :year_to_date, where(:status_change_date => Date.today.beginning_of_year..Date.today.end_of_year)
#
#   def self.type_by_month_year(month, year, shelter_id=nil, state=nil)
#     start_date = (month.blank? or year.blank?) ? Date.today : Date.civil(year.to_i, month.to_i, 01)
#     range = start_date.beginning_of_month..start_date.end_of_month
#     status_histories = StatusHistory.where(:shelter_id => shelter_id || {}).by_month(range)
#
#     scope = self.scoped
#     scope = scope.select("count(*) count, animal_types.name")
#     scope = scope.joins(:status_histories, :animal_type)
#     unless state.blank?
#       scope = scope.joins(:shelter)
#       scope = scope.where(:shelters => { :state => state })
#     end
#     scope = scope.where(:status_histories => {:id => status_histories})
#     scope = scope.where(:animal_status_id => AnimalStatus::ACTIVE)
#     scope = scope.group(:animal_type_id)
#     scope
#   end
#
#   def self.intake_totals_by_month(year, with_type=false)
#     start_date = year.blank? ? Date.today.beginning_of_year : Date.parse("#{year}0101").beginning_of_year
#     end_date = year.blank? ? Date.today.end_of_year : Date.parse("#{year}0101").end_of_year
#     scope = self.scoped
#
#     if with_type
#       scope = scope.select("animal_types.name as type").joins(:animal_type).group(:animal_type_id)
#     else
#       scope = scope.select("'Total' as type")
#     end
#
#     start_date.month.upto(end_date.month) do |month|
#       scope = scope.select("COUNT(CASE WHEN animals.created_at BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
#       start_date = start_date.next_month
#     end
#     scope = scope.reorder(nil).limit(nil)
#     scope
#   end
#   #----------------------------------------------------------------------------
#
#   # Instance Methods
#   #----------------------------------------------------------------------------
#
#   #-----------------------------------------------------------------------------
#   private
#
#   def is_kill_shelter?
#     @shelter ||= self.shelter.kill_shelter?
#   end
#
#   # FIXME: Hack to set the name based on what is should be, view can be lowercase
#   # Please fix this by adding the breed ids instead of the names to the animal model primary_breed_id, secondary_breed_id
#   def update_breed_names
#     unless self.primary_breed.blank?
#       primary_breed_from_db = Breed.where(:name => self.primary_breed).first
#       self.primary_breed = primary_breed_from_db.name if primary_breed_from_db
#     end
#     unless self.primary_breed.blank?
#       secondary_breed_from_db = Breed.where(:name => self.secondary_breed).first
#       self.secondary_breed = secondary_breed_from_db.name if secondary_breed_from_db
#     end
#   end
#
#   def change_status_date!
#     if self.new_record? or self.animal_status_id_changed?
#       self.status_change_date = Date.today
#     end
#   end
#
#   def status_history_reason_required?
#     self.animal_status_id.present? and (self.new_record? or self.animal_status_id_changed?)
#   end
#
#   def create_status_history!
#     StatusHistory.create_with(self.shelter_id, self.id, self.animal_status_id, @status_history_reason) if self.new_record? or self.animal_status_id_changed? or self.shelter_id_changed?
#   end
#
#   def clean_fields
#     clean_description
#     clean_secondary_breed
#     clean_special_needs
#   end
#
#   def clean_description
#     # Remove Microsoft Extra Smart Formatting
#     unless self.description.blank?
#       self.description.strip!
#       self.description.gsub!(/[\u201C\u201D\u201E\u201F\u2033\u2036]/, '"')
#       self.description.gsub!(/[\u2018\u2019\u201A\u201B\u2032\u2035\uFFFD]/, "'")
#       self.description.gsub!(/[\u2013\u2014]/, "-")
#       self.description.gsub!(/\u02C6/, '^')
#       self.description.gsub!(/\u2039/, '<')
#       self.description.gsub!(/\u203A/, '>')
#       self.description.gsub!(/\u2013/, '-')
#       self.description.gsub!(/\u2014/, '--')
#       self.description.gsub!(/\u2026/, '...')
#       self.description.gsub!(/\u00A9/, '&copy;')
#       self.description.gsub!(/\u00AE/, '&reg;')
#       self.description.gsub!(/\u2122/, '&trade;')
#       self.description.gsub!(/\u00BC/, '&frac14;')
#       self.description.gsub!(/\u00BD/, '&frac12;')
#       self.description.gsub!(/\u00BE/, '&frac34;')
#       self.description.gsub!(/[\u02DC\u00A0]/, " ")
#     end
#   end
#
#   def clean_secondary_breed
#     self.secondary_breed = nil unless self.mix_breed?
#   end
#
#   def clean_special_needs
#     self.special_needs = nil unless self.special_needs?
#   end
# end

describe Animal do

  it_should_behave_like Statusable
  it_should_behave_like Typeable
  it_should_behave_like Uploadable

  it "has a default scope" do
    Animal.scoped.to_sql.should == Animal.order('animals.updated_at DESC').to_sql
  end

  it "validates presence of name" do
    animal = Animal.new :name => nil
    animal.should have(1).error_on(:name)
    animal.errors[:name].should == ["cannot be blank"]
  end

  it "validates presence of animal type id" do
    animal = Animal.new :animal_type_id => nil
    animal.should have(1).error_on(:animal_type_id)
    animal.errors[:animal_type_id].should == ["needs to be selected"]
  end

  it "validates presence of animal status id" do
    animal = Animal.new :animal_status_id => nil
    animal.should have(1).error_on(:animal_status_id)
    animal.errors[:animal_status_id].should == ["needs to be selected"]
  end

  it "validates breed of primary breed" do
    animal = Animal.gen :primary_breed => nil, :animal_type_id => 1
    animal.should have(1).error_on(:primary_breed)
    animal.errors[:primary_breed].should == ["cannot be blank"]

    animal = Animal.new :primary_breed => "aaa", :animal_type_id => 1
    animal.should have(1).error_on(:primary_breed)
    animal.errors[:primary_breed].should == ["must contain a valid breed name"]
  end

  it "validates breed of secondary breed" do
    animal = Animal.new :is_mix_breed => true, :secondary_breed => nil, :animal_type_id => 1
    animal.should have(0).error_on(:secondary_breed)

    animal = Animal.new :is_mix_breed => true, :secondary_breed => "aaa", :animal_type_id => 1
    animal.should have(1).error_on(:secondary_breed)
    animal.errors[:secondary_breed].should == ["must contain a valid breed name"]
  end

  it "validates presence of sex" do
    animal = Animal.new :sex => nil
    animal.should have(1).error_on(:sex)
    animal.errors[:sex].should == ["cannot be blank"]
  end

  it "validates presence of age if status is active" do
    animal = Animal.new :age => nil, :animal_status_id => 1
    animal.should have(1).error_on(:age)
    animal.errors[:age].should == ["needs to be selected"]

    animal = Animal.new :age => nil, :animal_status_id => 2
    animal.should have(0).error_on(:age)
  end

  it "validates presence of size if status is active" do
    animal = Animal.new :size => nil, :animal_status_id => 1
    animal.should have(1).error_on(:size)
    animal.errors[:size].should == ["needs to be selected"]

    animal = Animal.new :size => nil, :animal_status_id => 2
    animal.should have(0).error_on(:size)
  end

  it "validates uniqueness of microchip" do
    shelter = Shelter.gen
    Animal.gen :microchip => "microchip", :shelter => shelter

    animal = Animal.new :microchip => "microchip", :shelter => shelter
    animal.should have(1).error_on(:microchip)
    animal.errors[:microchip].should == [
      "already exists in your shelter. Please return to the main Animal page and search by this microchip number to locate this record."
    ]

    # Another Shelter
    animal = Animal.new :microchip => "microchip"
    animal.should have(0).error_on(:microchip)
  end

  it "validates allows blank for microchip" do
    animal = Animal.new :microchip => nil
    animal.should have(0).error_on(:microchip)
  end

  it "validates presence of special needs" do
    animal = Animal.new :has_special_needs => true
    animal.should have(1).error_on(:special_needs)
    animal.errors[:special_needs].should == ["cannot be blank"]
  end

  it "validates video url format of video url" do
    animal = Animal.new :video_url => "http://vimeo.com/1234"
    animal.should have(1).error_on(:video_url)
    animal.errors[:video_url].should == ["incorrect You Tube URL format"]
  end

  it "validates allows blank for video url" do
    animal = Animal.new :video_url => nil
    animal.should have(0).error_on(:video_url)
  end

  it "validates date format of date of birth before today" do
    today = Date.today + 1.month
    animal = Animal.gen(
      :date_of_birth_day => today.day,
      :date_of_birth_month => today.month,
      :date_of_birth_year => today.year
    )
    animal.should have(1).error_on(:date_of_birth)
    animal.errors[:date_of_birth].should == ["has to be before today's date"]
  end

  it "validates date format of date of birth invalid date" do
    today = Date.today
    animal = Animal.new(
      :date_of_birth_day => today.day,
      :date_of_birth_month => today.month,
      :date_of_birth_year => nil
    )
    animal.should have(1).error_on(:date_of_birth)
    animal.errors[:date_of_birth].should == ["is an invalid date format"]
  end

  it "validates date format of arrival date invalid date" do
    today = Date.today
    animal = Animal.new(
      :arrival_date_day => today.day,
      :arrival_date_month => today.month,
      :arrival_date_year => nil
    )
    animal.should have(1).error_on(:arrival_date)
    animal.errors[:arrival_date].should == ["is an invalid date format"]
  end

  it "validates date format of euthanasia date invalid date" do
    today = Date.today
    animal = Animal.new(
      :euthanasia_date_day => today.day,
      :euthanasia_date_month => today.month,
      :euthanasia_date_year => nil
    )
    animal.should have(1).error_on(:euthanasia_date)
    animal.errors[:euthanasia_date].should == ["is an invalid date format"]
  end

  context "Nested Attributes" do
#   accepts_nested_attributes_for :photos, :limit => Photo::MAX_TOTAL,
#                                          :allow_destroy => true,
#                                          :reject_if => Proc.new { |a| a['image'].blank? if a['image_cache'].blank? }
  end

  context "Before Save" do
  ##   before_save :change_status_date!, :clean_fields
  end

  context "After Validation" do
#   after_validation :update_breed_names # FIXME: Remove later when we store the breed ids
  end

  context "After Save" do
#   after_save :create_status_history!
  end
end

# Constants
#----------------------------------------------------------------------------
describe Animal, "::SEX" do
  it "contains a default list of genders" do
    Animal::SEX.should == ["male", "female"]
  end
end

describe Animal, "::AGES" do
  it "contains a default list of ages" do
    Animal::AGES.should == ["baby", "young", "adult", "senior"]
  end
end

describe Animal, "::SIZES" do
  it "contains a default list of sizes" do
    Animal::SIZES.should == {
      :S => "Small",
      :M => "Medium",
      :L => "Large",
      :XL => "X-Large"
    }
  end
end

# Class Methods
#----------------------------------------------------------------------------


# Instance Methods
#----------------------------------------------------------------------------
describe Animal, "#animal_type" do

  it "belongs to an animal type" do
    animal_type = AnimalType.new
    animal = Animal.new :animal_type => animal_type

    animal.animal_type.should == animal_type
  end

  it "returns a readonly animal type" do
    animal = Animal.gen
    animal.reload.animal_type.should be_readonly
  end
end

describe Animal, "#animal_status" do

  it "belongs to an animal status" do
    animal_status = AnimalStatus.new
    animal = Animal.new :animal_status => animal_status

    animal.animal_status.should == animal_status
  end

  it "returns a readonly animal status" do
    animal = Animal.gen
    animal.reload.animal_status.should be_readonly
  end
end

describe Animal, "#accommodation" do

  it "belongs to an accommodation" do
    accommodation = Accommodation.new
    animal = Animal.new :accommodation => accommodation

    animal.accommodation.should == accommodation
  end
end

describe Animal, "#shelter" do

  it "belongs to an shelter" do
    shelter = Shelter.new
    animal = Animal.new :shelter => shelter

    animal.shelter.should == shelter
  end
end

describe Animal, "#placements" do

  before do
    @animal = Animal.gen
    @placement1 = Placement.gen :animal => @animal
    @placement2 = Placement.gen :animal => @animal
  end

  it "returns a list of placements" do
    @animal.placements.count.should == 2
    @animal.placements.should =~ [@placement1, @placement2]
  end

  it "destroy all placements associated to the animal" do
    @animal.placements.count.should == 2
    @animal.destroy
    @animal.placements.count.should == 0
  end
end

describe Animal, "#notes" do

  before do
    @animal = Animal.gen
    @note1 = Note.gen :notable => @animal
    @note2 = Note.gen :notable => @animal
  end

  it "returns a list of notes" do
    @animal.notes.count.should == 2
    @animal.notes.should =~ [@note1, @note2]
  end

  it "destroy all notes associated to the animal" do
    @animal.notes.count.should == 2
    @animal.destroy
    @animal.notes.count.should == 0
  end
end

describe Animal, "#alerts" do

  before do
    @animal = Animal.gen
    @alert1 = Alert.gen :alertable => @animal
    @alert2 = Alert.gen :alertable => @animal
  end

  it "returns a list of alerts" do
    @animal.alerts.count.should == 2
    @animal.alerts.should =~ [@alert1, @alert2]
  end

  it "destroy all alerts associated to the animal" do
    @animal.alerts.count.should == 2
    @animal.destroy
    @animal.alerts.count.should == 0
  end
end

describe Animal, "#tasks" do

  before do
    @animal = Animal.gen
    @task1 = Task.gen :taskable => @animal
    @task2 = Task.gen :taskable => @animal
  end

  it "returns a list of tasks" do
    @animal.tasks.count.should == 2
    @animal.tasks.should =~ [@task1, @task2]
  end

  it "destroy all tasks associated to the animal" do
    @animal.tasks.count.should == 2
    @animal.destroy
    @animal.tasks.count.should == 0
  end
end

describe Animal, "#transfers" do

  before do
    @animal = Animal.gen
    @transfer1 = Transfer.gen :animal => @animal
    @transfer2 = Transfer.gen :animal => @animal
  end

  it "returns a list of transfers" do
    @animal.transfers.count.should == 2
    @animal.transfers.should =~ [@transfer1, @transfer2]
  end

  it "destroy all transfers associated to the animal" do
    @animal.transfers.count.should == 2
    @animal.destroy
    @animal.transfers.count.should == 0
  end
end

describe Animal, "#status_histories" do

  before do
    @animal = Animal.gen
    @status_history1 = StatusHistory.gen :animal => @animal
    @status_history2 = StatusHistory.gen :animal => @animal
  end

  it "returns a list of status_histories" do
    @animal.status_histories.count.should == 3
    @animal.status_histories.should include(@status_history1, @status_history2)
  end

  it "destroy all status_histories associated to the animal" do
    @animal.status_histories.count.should == 3
    @animal.destroy
    @animal.status_histories.count.should == 0
  end
end

describe Animal, "#photos" do

  before do
    @animal = Animal.gen
    @photo1 = Photo.gen :attachable => @animal
    @photo2 = Photo.gen :attachable => @animal
  end

  it "returns a list of photos" do
    @animal.photos.count.should == 2
    @animal.photos.should =~ [@photo1, @photo2]
  end

  it "destroy all photos associated to the animal" do
    @animal.photos.count.should == 2
    @animal.destroy
    @animal.photos.count.should == 0
  end
end

#   def full_breed
#     if mix_breed?
#       self.secondary_breed.blank? ? self.primary_breed + " Mix" : self.primary_breed + " & " + self.secondary_breed + " Mix"
#     else
#       self.primary_breed
#     end
#   end
#
#   def special_needs?
#     self.has_special_needs
#   end
#
#   def mix_breed?
#     self.is_mix_breed
#   end
#
#   def sterilized?
#     self.is_sterilized
#   end
#
#   # def photos?
#   #   self.photos.present?
#   # end
#
