require "rails_helper"

describe TasksHelper, "#show_taskable_link" do

  it "returns no link" do
    task = Task.gen

    expect(
      helper.show_taskable_link(task)
    ).to be_nil
  end

  it "returns a link for an taskable" do
    animal = Animal.gen
    task = Task.gen :taskable => animal

    allow(controller).to receive(:controller_name).and_return("tasks")

    expect(
      helper.show_taskable_link(task)
    ).to eq("<span class='taskable_link'>(<a href=\"#{animal_path(animal)}\">#{animal.name}</a>)</span>")
  end
end

describe TasksHelper, "#display_due_date" do

  context "with no due_date" do
    it "returns no link" do
      task = Task.gen :due_date => Date.today

      expect(
        helper.display_due_date(task)
      ).to be_nil
    end
  end

  context "with due_date" do

    it "returns no link when today" do
      task = Task.gen :due_date => Date.today, :due_category => "today"

      expect(
        helper.display_due_date(task)
      ).to be_nil
    end

    it "returns no link when tomorrow" do
      task = Task.gen :due_date => Date.tomorrow, :due_category => "tomorrow"

      expect(
        helper.display_due_date(task)
      ).to be_nil
    end

    it "returns link" do
      Timecop.freeze(Time.parse("Fri, 14 Feb 2014"))
      task = Task.gen :due_date => Date.today + 5.days, :due_category => "later"

      expect(
        helper.display_due_date(task)
      ).to eq("<span class='task_due_date'>Feb 19</span>")
    end
  end

end

