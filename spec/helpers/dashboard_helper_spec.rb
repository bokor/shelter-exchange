require "rails_helper"

describe DashboardHelper, "#activity_message_for" do

  it "calls correct method for object" do
    animal = Animal.gen
    allow(helper).to receive(:animal_message).with(animal).and_return("CALLED")

    expect(
      helper.activity_message_for(animal)
    ).to eq("CALLED")
  end
end

describe DashboardHelper, "#animal_message" do

  it "returns text for a new animal record" do
    animal = Animal.gen :name => "Billy"

    expect(
      helper.animal_message(animal)
    ).to eq("A new animal record for <a href=\"/animals/#{animal.id}\">Billy</a> has been created.")
  end

  it "returns text for an animal status changed" do
    animal = nil
    status = AnimalStatus.gen :name => "Adopted"

    Timecop.freeze(Time.parse("Fri, 14 Feb 2013")) do
      animal = Animal.gen :name => "Billy", :animal_status_id => status.id
    end

    animal.status_change_date = Time.zone.today
    animal.save

    expect(
      helper.animal_message(animal)
    ).to eq("<a href=\"/animals/#{animal.id}\">Billy&#x27;s</a> status was changed to <strong>'#{status.name}'</strong>")
  end

  it "returns text when an animal has been updated" do
    animal = Animal.gen :name => "Billy", :updated_at => Date.new(2014, 02, 14)

    expect(
      helper.animal_message(animal)
    ).to eq("<a href=\"/animals/#{animal.id}\">Billy&#x27;s</a> record has been updated.")
  end
end

describe DashboardHelper, "#task_message" do

  it "returns text for a new task record" do
    task = Task.gen :details => "this is a new task", :category => "email"

    expect(
      helper.task_message(task)
    ).to eq("New - Email - this is a new task.")
  end

  it "returns text for a completed task" do
    task = Task.gen \
      :details => "this is a new task",
      :category => "email",
      :completed => true,
      :updated_at => Date.new(2014, 02, 14)

    expect(
      helper.task_message(task)
    ).to eq("<span class='completed'>Email - this is a new task is complete.</span>")
  end

  it "returns text for a updated task" do
    task = Task.gen \
      :details => "this is a new task",
      :category => "email",
      :updated_at => Date.new(2014, 02, 14)

    expect(
      helper.task_message(task)
    ).to eq("Email - this is a new task was updated.")
  end

  context "with polymorphic link" do

    it "returns text for a new task record" do
      animal = Animal.gen :name => "Billy"
      task = Task.gen :details => "this is a new task", :category => "email", :taskable => animal

      expect(
        helper.task_message(task)
      ).to eq("New - Email - this is a new task for <span class='polymorphic_link'><a href=\"/animals/#{animal.id}\">Billy</a></span>.")
    end

    it "returns text for a completed task" do
      animal = Animal.gen :name => "Billy"
      task = Task.gen \
        :details => "this is a new task",
        :category => "email",
        :completed => true,
        :updated_at => Date.new(2014, 02, 14),
        :taskable => animal

      expect(
        helper.task_message(task)
      ).to eq("<span class='completed'>Email - this is a new task is complete for <span class='polymorphic_link'><a href=\"/animals/#{animal.id}\">Billy</a></span>.</span>")
    end

    it "returns text for a updated task" do
      animal = Animal.gen :name => "Billy"
      task = Task.gen \
        :details => "this is a new task",
        :category => "email",
        :updated_at => Date.new(2014, 02, 14),
        :taskable => animal

      expect(
        helper.task_message(task)
      ).to eq("Email - this is a new task was updated for <span class='polymorphic_link'><a href=\"/animals/#{animal.id}\">Billy</a></span>.")
    end
  end
end

describe DashboardHelper, "#show_polymorphic_link" do

  it "returns a link for an task object" do
    animal = Animal.gen :name => "Billy"
    task = Task.gen :taskable => animal

    expect(
      helper.show_polymorphic_link(task)
    ).to eq(" for <span class='polymorphic_link'><a href=\"/animals/#{animal.id}\">Billy</a></span>")
  end
end

