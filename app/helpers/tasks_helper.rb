module TasksHelper
  
  def find_due_section
    due_section = @task.due_category
    if @task.due_date.blank? or @task.due_date > Date.today + 1.day or @task.due_category == 'later'
      due_section = "later"
    elsif @task.due_date < Date.today
      due_section = "overdue"
    elsif @task.due_date == Date.today
      due_section = "today"
    elsif @task.due_date == Date.today + 1.day
      due_section = "tomorrow"
    end
  end
  
end
