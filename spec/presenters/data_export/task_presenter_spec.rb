require 'rails_helper'

describe DataExport::TaskPresenter do

  before do
    @task = Task.gen
  end

  describe "#id" do
    it "returns the task id" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.id).to eq(@task.id)
    end
  end

  describe "#details" do
    it "returns the task details" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.details).to eq(@task.details)
    end
  end

  describe "#additional_info" do
    it "returns the task additional_info" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.additional_info).to eq(@task.additional_info)
    end
  end

  describe "#due_at" do
    it "returns the task due_at" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.due_at).to eq(@task.due_at)
    end
  end

  describe "#due_date" do
    it "returns the task due_date" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.due_date).to eq(@task.due_date)
    end
  end

  describe "#category" do
    it "returns the task category" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.category).to eq(@task.category)
    end
  end

  describe "#completed" do
    it "returns yes when the task has been completed" do
      @task.update_column(:completed, true)
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.completed).to eq("Yes")
    end

    it "returns no when the task has not been completed" do
      @task.update_column(:completed, false)
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.completed).to eq("No")
    end
  end

  describe "#animal_id" do
    it "returns empty when an animal is not attached to the task" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.animal_id).to be_nil
    end
  end

  context "with animal attached" do
    before do
      @animal = Animal.gen
      @task.taskable = @animal
      @task.save!
    end

    describe "#animal_id" do
      it "returns the id of the animal attached to the task" do
        presenter = DataExport::TaskPresenter.new(@task)
        expect(presenter.animal_id).to eq(@animal.id)
      end
    end
  end

  describe "#create_at" do
    it "returns the task created_at timestamp" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.created_at).to eq(@task.created_at)
    end
  end

  describe "#updated_at" do
    it "returns the task updated_at timestamp" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.updated_at).to eq(@task.updated_at)
    end
  end

  describe "#to_csv" do

    it "returns the task in a csv row format" do
      presenter = DataExport::TaskPresenter.new(@task)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.details,
        presenter.additional_info,
        presenter.due_at,
        presenter.due_date,
        presenter.category,
        presenter.completed,
        presenter.animal_id,
        presenter.created_at,
        presenter.updated_at
      ])
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        DataExport::TaskPresenter.csv_header

      ).to eq([
        "Id",
        "Details",
        "Additional Info",
        "Due At",
        "Due Date",
        "Category",
        "Completed",
        "Animal Id",
        "Created At",
        "Updated At"
      ])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      task1 = Task.gen
      task2 = Task.gen
      csv = []

      DataExport::TaskPresenter.as_csv([task1,task2], csv)

      expect(csv).to match_array([
        DataExport::TaskPresenter.csv_header,
        DataExport::TaskPresenter.new(task1).to_csv,
        DataExport::TaskPresenter.new(task2).to_csv
      ])
    end
  end
end


