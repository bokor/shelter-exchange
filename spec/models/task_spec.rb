require "rails_helper"

describe Task do

  it "has a default scope" do
    expect(Task.scoped.to_sql).to eq(Task.order('tasks.due_date ASC, tasks.updated_at DESC').to_sql)
  end

  it "requires presence of details" do
    task = Task.gen :details => nil

    expect(task.valid?).to be_falsey
    expect(task.errors[:details].size).to eq(1)
    expect(task.errors[:details]).to match_array(["cannot be blank"])
  end
end

# Constants
#----------------------------------------------------------------------------
describe Task, "::CATEGORIES" do

  it "contains a default list of Categories" do
    expect(Task::CATEGORIES).to match_array(["call", "email", "follow-up", "meeting", "to-do", "educational", "behavioral", "medical"])
  end
end

describe Task, "::DUE_CATEGORIES" do

  it "contains a default list of Due Categories" do
    expect(Task::DUE_CATEGORIES).to match_array(["today", "tomorrow", "later", "specific_date"])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Task, ".active" do

  it "returns only the active alerts" do
    task1 = Task.gen :completed => false
    Task.gen :completed => true

    tasks = Task.active.all

    expect(tasks.count).to eq(1)
    expect(tasks).to match_array([task1])
  end
end

describe Task, ".completed" do

  it "returns only the completed tasks" do
    task1 = Task.gen :completed => true
    Task.gen :completed => false

    tasks = Task.completed.all

    expect(tasks.count).to eq(1)
    expect(tasks).to match_array([task1])
  end
end

describe Task, ".overdue" do

  it "returns all of the overdue tasks" do
    task1 = Task.gen :due_date => Date.today - 1.day
    Task.gen :due_date => Date.today

    tasks = Task.overdue.all

    expect(tasks.count).to eq(1)
    expect(tasks).to match_array([task1])
  end
end

describe Task, ".today" do

  it "returns all of the tasks due today" do
    task1 = Task.gen :due_date => Date.today - 1.day
    Task.gen :due_date => Date.today

    tasks = Task.overdue.all

    expect(tasks.count).to eq(1)
    expect(tasks).to match_array([task1])
  end
end

describe Task, ".tomorrow" do

  it "returns all of the tasks due tomorrow" do
    task1 = Task.gen :due_date => Date.today + 1.day
    Task.gen :due_date => Date.today

    tasks = Task.tomorrow.all

    expect(tasks.count).to eq(1)
    expect(tasks).to match_array([task1])
  end
end

describe Task, ".later" do

  it "returns all of the tasks due later" do
    task1 = Task.gen :due_date => Date.today + 2.day
    Task.gen :due_date => Date.today

    tasks = Task.later.all

    expect(tasks.count).to eq(1)
    expect(tasks).to match_array([task1])
  end
end

describe Task, ".recent_activity" do

  it "returns only the most recent activity per limit" do
    task1 = Task.gen :updated_at => Time.now - 1.hour
    task2 = Task.gen :updated_at => Time.now, :taskable => Item.gen
    Task.gen :updated_at => Time.now - 2.hour

    results = Task.recent_activity(2).all

    expect(results.count).to eq(2)
    expect(results).to match_array([task1, task2])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Task, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.new
    task = Task.new :shelter => shelter

    expect(task.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    task = Task.gen
    expect(task.reload.shelter).to be_readonly
  end
end

describe Note, "#taskable" do

  it "belongs to a taskable object" do
    item = Item.new
    animal = Animal.new
    task1 = Task.new :taskable => item
    task2 = Task.new :taskable => animal

    expect(task1.taskable).to eq(item)
    expect(task1.taskable).to be_instance_of(Item)

    expect(task2.taskable).to eq(animal)
    expect(task2.taskable).to be_instance_of(Animal)
  end
end

describe Task, "#taskable?" do

  it "returns true if the task is taskable" do
    item = Item.new
    task1 = Task.new :taskable => item
    task2 = Task.new

    expect(task1.taskable?).to eq(true)
    expect(task2.taskable?).to eq(false)
  end
end

describe Task, "#completed?" do

  it "returns true if the task has been completed" do
    task1 = Task.new :completed => true
    task2 = Task.new :completed => false

    expect(task1.completed?).to eq(true)
    expect(task2.completed?).to eq(false)
  end
end

describe Task, "#overdue?" do

  it "returns true if the task has been overdue" do
    task1 = Task.new :due_date => Date.today - 1.day
    task2 = Task.new :due_date => Date.today + 1.day

    expect(task1.overdue?).to eq(true)
    expect(task2.overdue?).to eq(false)
  end
end

describe Task, "#today?" do

  it "returns true if the task is due today" do
    task1 = Task.new :due_date => Date.today
    task2 = Task.new :due_date => Date.today + 1.day

    expect(task1.today?).to eq(true)
    expect(task2.today?).to eq(false)
  end
end

describe Task, "#tomorrow?" do

  it "returns true if the task is due tomorrow" do
    task1 = Task.new :due_date => Date.today + 1.day
    task2 = Task.new :due_date => Date.today

    expect(task1.tomorrow?).to eq(true)
    expect(task2.tomorrow?).to eq(false)
  end
end

describe Task, "#later?" do

  it "returns true if the task is due later" do
    task1 = Task.new :due_date => Date.today + 2.days
    task2 = Task.new :due_category => "later"
    task3 = Task.new :due_date => Date.today

    expect(task1.later?).to eq(true)
    expect(task2.later?).to eq(true)
    expect(task3.later?).to eq(false)
  end
end

describe Task, "#specific_date?" do

  it "returns true if the task is due later" do
    task1 = Task.new :due_category => "specific_date"
    task2 = Task.new :due_category => "later"

    expect(task1.specific_date?).to eq(true)
    expect(task2.specific_date?).to eq(false)
  end
end

describe Task, "#due_section" do

  it "returns overdue" do
    task = Task.new :due_date => Date.today - 1.day
    expect(task.due_section).to eq("overdue")
  end

  it "returns today" do
    task = Task.new :due_date => Date.today
    expect(task.due_section).to eq("today")
  end

  it "returns tomorrow" do
    task = Task.new :due_date => Date.today + 1.day
    expect(task.due_section).to eq("tomorrow")
  end

  it "returns later" do
    task = Task.new :due_date => Date.today + 2.days
    expect(task.due_section).to eq("later")
  end
end

