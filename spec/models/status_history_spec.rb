require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :readonly => true
# belongs_to :animal, :readonly => true
# belongs_to :animal_status, :readonly => true

describe StatusHistory do

  it "should have a default scope" do
pending "Need to implement"
    #default_scope :order => 'created_at DESC'
  end
end

describe StatusHistory, ".create_with" do
pending "Need to implement"
  #def self.create_with(shelter_id, animal_id, animal_status_id, reason)
    #create!(:shelter_id => shelter_id, :animal_id => animal_id, :animal_status_id => animal_status_id, :reason => reason)
  #end
end

# From StatusHistory::Reportable
describe StatusHistory, ".by_month" do
pending "Need to implement"
  #def by_month(range)
    #self.select([:id, :animal_id]).where(:created_at => range).reorder("animal_id, created_at DESC").uniq(&:animal_id).collect(&:id)
  #end
end

describe StatusHistory, ".status_by_month_year" do
pending "Need to implement"
  #def status_by_month_year(month, year, state=nil)
    #start_date = (month.blank? or year.blank?) ? Date.today : Date.civil(year.to_i, month.to_i, 01)
    #range = start_date.beginning_of_month..start_date.end_of_month

    #scope = scoped{}
    #scope = scope.select("count(*) count, animal_statuses.name")
    #scope = scope.joins(:animal_status)
    #unless state.blank?
      #scope = scope.joins(:shelter)
      #scope = scope.where(:shelters => { :state => state })
    #end
    #scope = scope.where(:status_histories => { :id => self.by_month(range) })
    #scope = scope.group("status_histories.animal_status_id").reorder(nil).limit(nil)
    #scope
  #end
end

describe StatusHistory, ".totals_by_month" do
pending "Need to implement"
  #def totals_by_month(year, status, with_type=false)
    #start_date = year.blank? ? Date.today.beginning_of_year : Date.parse("#{year}0101").beginning_of_year
    #end_date = year.blank? ? Date.today.end_of_year : Date.parse("#{year}0101").end_of_year
    #scope = scoped{}

    #if with_type
      #scope = scope.select("animal_types.name as type").joins(:animal => :animal_type).group(:animal_type_id)
    #else
      #scope = scope.select("'Total' as type")
    #end

    #start_date.month.upto(end_date.month) do |month|
      #scope = scope.select("COUNT(CASE WHEN status_histories.created_at BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
      #start_date = start_date.next_month
    #end
    #scope = scope.where(:animal_status_id => AnimalStatus::STATUSES[status]) unless status.blank?
    #scope = scope.reorder(nil).limit(nil)
    #scope
  #end
end


