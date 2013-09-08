require "spec_helper"

describe Task do

  it "has a default scope" do
    Task.scoped.to_sql.should == Task.order('tasks.due_date ASC, tasks.updated_at DESC').to_sql
  end

  it "requires presence of details" do
    task = Task.gen :details => nil
    task.should have(1).error_on(:details)
    task.errors[:details].should == ["cannot be blank"]
  end
end

# Constants
#----------------------------------------------------------------------------
describe Task, "::CATEGORIES" do

  it "contains a default list of Categories" do
    Task::CATEGORIES.should == ["call", "email", "follow-up", "meeting", "to-do", "educational", "behavioral", "medical"]
  end
end

describe Task, "::DUE_CATEGORIES" do

  it "contains a default list of Due Categories" do
    Task::DUE_CATEGORIES.should == ["today", "tomorrow", "later", "specific_date"]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Task, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.new
    task = Task.new :shelter => shelter

    task.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    task = Task.gen
    task.reload.shelter.should be_readonly
  end
end

describe Note, "#taskable" do

  it "belongs to a taskable object" do
    item   = Item.new
    animal = Animal.new
    task1  = Task.new :taskable => item
    task2  = Task.new :taskable => animal

    task1.taskable.should == item
    task1.taskable.should be_instance_of(Item)

    task2.taskable.should == animal
    task2.taskable.should be_instance_of(Animal)
  end
end

describe Task, "#taskable?" do

  it "validates if the task has an taskable association" do
    item  = Item.new
    task1 = Task.new :taskable => item
    task2 = Task.new

    task1.taskable?.should == true
    task2.taskable?.should == false
  end
end

describe Task, "#completed?" do

  it "validates if the task has been completed" do
    task1 = Task.new :completed => true
    task2 = Task.new :completed => false

    task1.completed?.should == true
    task2.completed?.should == false
  end
end

describe Task, "#overdue?" do

  it "validates if the task is overdue" do
    task1 = Task.new :due_date => Date.today - 1.day
    task2 = Task.new :due_date => Date.today + 1.day

    task1.overdue?.should == true
    task2.overdue?.should == false
  end
end

describe Task, "#today?" do

  it "validates if the task is due today" do
    task1 = Task.new :due_date => Date.today
    task2 = Task.new :due_date => Date.today + 1.day

    task1.today?.should == true
    task2.today?.should == false
  end
end

describe Task, "#tomorrow?" do

  it "validates if the task is due tomorrow" do
    task1 = Task.new :due_date => Date.today + 1.day
    task2 = Task.new :due_date => Date.today

    task1.tomorrow?.should == true
    task2.tomorrow?.should == false
  end
end

describe Task, "#later?" do

  it "validates if the task is due later" do
    task1 = Task.new :due_date => Date.today + 2.days
    task2 = Task.new :due_category => "later"
    task3 = Task.new :due_date => Date.today

    task1.later?.should == true
    task2.later?.should == true
    task3.later?.should == false
  end
end

describe Task, "#specific_date?" do

  it "validates if the task is due later" do
    task1 = Task.new :due_category => "specific_date"
    task2 = Task.new :due_category => "later"

    task1.specific_date?.should == true
    task2.specific_date?.should == false
  end
end

describe Task, "#due_section" do

  it "validates if the task is due later" do
    task1 = Task.new :due_category => "specific_date"
    task2 = Task.new :due_category => "later"

    task1.specific_date?.should == true
    task2.specific_date?.should == false
  end
end

describe Task, "#due_section" do

  it "returns overdue" do
    task = Task.new :due_date => Date.today - 1.day
    task.due_section.should == "overdue"
  end

  it "returns today" do
    task = Task.new :due_date => Date.today
    task.due_section.should == "today"
  end

  it "returns tomorrow" do
    task = Task.new :due_date => Date.today + 1.day
    task.due_section.should == "tomorrow"
  end

  it "returns later" do
    task = Task.new :due_date => Date.today + 2.days
    task.due_section.should == "later"
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Task, ".active" do

  it "returns only the active alerts" do
    task1 = Task.gen :completed => false
    task2 = Task.gen :completed => true

    tasks = Task.active.all

    tasks.count.should == 1
    tasks.should       == [task1]
  end
end

describe Task, ".completed" do

  it "returns only the completed tasks" do
    task1 = Task.gen :completed => true
    task2 = Task.gen :completed => false

    tasks = Task.completed.all

    tasks.count.should == 1
    tasks.should       == [task1]
  end
end

describe Task, ".overdue" do

  it "returns all of the overdue tasks" do
    task1 = Task.gen :due_date => Date.today - 1.day
    task2 = Task.gen :due_date => Date.today

    tasks = Task.overdue.all

    tasks.count.should == 1
    tasks.should       == [task1]
  end
end

describe Task, ".today" do

  it "returns all of the tasks due today" do
    task1 = Task.gen :due_date => Date.today - 1.day
    task2 = Task.gen :due_date => Date.today

    tasks = Task.overdue.all

    tasks.count.should == 1
    tasks.should       == [task1]
  end
end

describe Task, ".tomorrow" do

  it "returns all of the tasks due tomorrow" do
    task1 = Task.gen :due_date => Date.today + 1.day
    task2 = Task.gen :due_date => Date.today

    tasks = Task.tomorrow.all

    tasks.count.should == 1
    tasks.should       == [task1]
  end
end

describe Task, ".later" do

  it "returns all of the tasks due later" do
    task1 = Task.gen :due_date => Date.today + 2.day
    task2 = Task.gen :due_date => Date.today

    tasks = Task.later.all

    tasks.count.should == 1
    tasks.should       == [task1]
  end
end

describe Task, ".recent_activity" do

  it "returns only the most recent activity per limit" do
    task1 = Task.gen :updated_at => Time.now - 2.hour
    task2 = Task.gen :updated_at => Time.now - 1.hour
    task3 = Task.gen :updated_at => Time.now, :taskable => Item.gen

    results = Task.recent_activity(2).all

    results.count.should == 2
    results.should       == [task3, task2]
  end
end

