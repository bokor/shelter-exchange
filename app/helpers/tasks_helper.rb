module TasksHelper
  
  def show_taskable_link(task)
	  if task.taskable
	    link = link_to task.taskable.name, polymorphic_path(task.taskable)
	    return ('<span class="taskable_link">(' + link + ')</span>').html_safe
    end
  end
  
  def display_due_date(task)
    due_section = find_due_section(task)
    if !task.due_date.blank?
      unless due_section == "today" or due_section == "tomorrow"
        return ('<span class="task_due_date">' + format_date(:short_no_year, task.due_date) + '</span>').html_safe
      end
    end
  end
  
  def find_due_section(task)
    due_section = task.due_category
    if task.due_date.blank? or task.due_date > Date.today + 1.day or task.due_category == "later"
      due_section = "later"
    elsif task.due_date < Date.today
      due_section = "overdue"
    elsif task.due_date == Date.today
      due_section = "today"
    elsif task.due_date == Date.today + 1.day
      due_section = "tomorrow"
    end
  end
  
end
