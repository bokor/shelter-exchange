module TasksHelper
  
  def show_taskable_link(task)
	  if controller_name == "tasks" and task.taskable
	    link = link_to task.taskable.name, polymorphic_path(task.taskable)
	    return ('<span class="taskable_link">(' + link + ')</span>').html_safe
    end
  end
  
  def display_due_date(task)
    # due_section = find_due_section(task)
    if task.due_date.present?
      unless task.today? or task.tomorrow?
        return ('<span class="task_due_date">' + format_date(:short_no_year, task.due_date) + '</span>').html_safe
      end
    end
  end
  
end
