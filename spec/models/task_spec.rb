#require "spec_helper"

#describe Note do

  #it "should have a default scope" do
    #Note.scoped.to_sql.should == Note.order('notes.created_at DESC').to_sql
  #end

  #it "should require presence of title" do
    #note = Note.gen
    #note.should have(:no).error_on(:title)

    #note = Note.gen :title => nil
    #note.should have(1).error_on(:title)
    #note.errors[:title].should == ["cannot be blank"]
  #end

  #it "should require inclusion of category" do
    #note = Note.gen
    #note.should have(:no).error_on(:category)

    #note = Note.gen :category => "#{Note::CATEGORIES[0]} blah"
    #note.should have(1).error_on(:category)
    #note.errors[:category].should == ["needs to be selected"]
  #end
#end

#describe Note, "::DEFAULT_CATEGORY" do
  #it "should contain a single value for the default category" do
    #Note::DEFAULT_CATEGORY.should == "general"
  #end
#end

#describe Note, "::CATEGORIES" do
  #it "should contain a default list of Categories" do
    #Note::CATEGORIES.should == [
      #"general", "medical", "behavioral", "intake"
    #]
  #end
#end

## Instance Methods
##----------------------------------------------------------------------------
#describe Note, "#shelter" do

  #it "should belong to a shelter" do
    #shelter = Shelter.gen
    #note = Note.gen :shelter => shelter

    #note.should respond_to(:shelter)
    #note.shelter.should == shelter
  #end

  #it "should return a readonly shelter" do
    #note = Note.gen
    #note.reload.shelter.should be_readonly
  #end
#end

#describe Note, "#notable" do

  #it "should belong to a notable object" do
    #item   = Item.gen
    #animal = Animal.gen
    #note1  = Note.gen :notable => item
    #note2  = Note.gen :notable => animal

    #note1.should respond_to(:notable)
    #note1.notable.should == item
    #note1.notable.should be_instance_of(Item)

    #note2.should respond_to(:notable)
    #note2.notable.should == animal
    #note2.notable.should be_instance_of(Animal)
  #end
#end

#describe Note, "#notable?" do

  #it "should validate if the note has an notable association" do
    #item  = Item.gen
    #note1 = Note.gen :notable => item
    #note2 = Note.gen

    #note1.notable?.should == true
    #note2.notable?.should == false
  #end
#end




require "spec_helper"

# TODO: Need to figure out how to TEST these
#-----------------------------------------------
# belongs_to :shelter, :readonly => true
# belongs_to :taskable, :polymorphic => true

describe Task do

  it "should have a default scope" do
    #default_scope :order => 'due_date ASC, updated_at DESC'
  end

  it "should require details" do
    #validates :details, :presence => true
  end
end

describe Task, "::CATEGORIES" do
  it "should contain a default list of Categories" do
    #Task::CATEGORIES.should == ["call", "email", "follow-up", "meeting", "to-do", "educational", "behavioral", "medical"]
  end
end

describe Task, "::DUE_CATEGORIES" do
  it "should contain a default list of Due Categories" do
    #Task::DUE_CATEGORIES.should == ["today", "tomorrow", "later", "specific_date"]
  end
end

describe Task, ".active" do
  #scope :active, where(:completed => false)
end

describe Task, ".completed" do
  #scope :completed, where(:completed => true)
end

describe Task, ".overdue" do
  #scope :overdue, where("due_date < ?", Date.today) # ??? Time.zone.now.midnight.to_date
end

describe Task, ".today" do
  #scope :today, where("due_date = ?", Date.today)
end

describe Task, ".tomorrow" do
  #scope :tomorrow, where("due_date = ?", Date.today + 1.day)
end

describe Task, ".later" do
  #scope :later, where("due_category = ? OR due_date > ?", "later", Date.today + 1.day).order("due_date DESC")
end

describe Task, ".recent_activity" do
  #def self.recent_activity(limit=10)
    #includes(:taskable).reorder("tasks.updated_at DESC").limit(limit)
  #end
end

describe Task, "#taskable?" do
  #def taskable?
    #!!self.taskable
  #end
end

describe Task, "#completed?" do
  #def completed?
    #self.completed
  #end
end

describe Task, "#overdue?" do
  #def overdue?
    #self.due_date.present? and self.due_date < Date.today
  #end
end

describe Task, "#today?" do
  #def today?
    #self.due_date.present? and self.due_date == Date.today
  #end
end

describe Task, "#tomorrow?" do
  #def tomorrow?
    #self.due_date.present? and self.due_date == Date.today + 1.day
  #end
end

describe Task, "#later?" do
  #def later?
    #self.due_date.blank? or self.due_date > Date.today + 1.day or self.due_category == "later"
  #end
end

describe Task, "#specific_date?" do
  #def specific_date?
    #self.due_category == "specific_date"
  #end
end

describe Task, "#due_section" do
  #def due_section
    #due_section = self.due_category
    #if self.later?
      #due_section = "later"
    #elsif self.overdue?
      #due_section = "overdue"
    #elsif self.today?
      #due_section = "today"
    #elsif self.tomorrow?
      #due_section = "tomorrow"
    #end
  #end
end

