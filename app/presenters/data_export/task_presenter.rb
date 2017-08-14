class DataExport::TaskPresenter < Presenter

  def initialize(task)
    @task = task
  end

  def id
    @task.id
  end

  def details
    @task.details
  end

  def additional_info
    @task.additional_info
  end

  def due_at
    @task.due_at
  end

  def due_date
    @task.due_date
  end

  def category
    @task.category.humanize if @task.category
  end

  def completed
    @task.completed ? "Yes" : "No"
  end

  def animal_id
    @task.taskable_id if @task.taskable? && @task.taskable_type == "Animal"
  end

  def created_at
    @task.created_at
  end

  def updated_at
    @task.updated_at
  end

  def to_csv
    [
      id,
      details,
      additional_info,
      due_at,
      due_date,
      category,
      completed,
      animal_id,
      created_at,
      updated_at
    ]
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.csv_header
    [
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
    ]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end
end


