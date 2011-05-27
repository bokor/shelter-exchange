module DashboardHelper
  
  def activity_message_for(object)
    send(object.class.name.to_s.downcase + "_message", object)
  end
  
  def animal_message(animal)
    if animal.updated_at == animal.created_at
      "#{link_to possessive(animal.name), animal} was created"
    elsif animal.status_change_date == animal.updated_at.to_date
      "#{link_to possessive(animal.name), animal} status was changed to <strong>'#{animal.animal_status.name}'</strong>"
    else
      "#{link_to possessive(animal.name), animal} was updated"
    end.html_safe
  end
  
  def alert_message(alert)
    if alert.updated_at == alert.created_at
      "#{alert.title} - Created"
    elsif alert.is_stopped
      "#{alert.title} - Completed"
    else
      "#{alert.title} - Updated"
    end.html_safe
  end
  
  def task_message(task)
    if task.updated_at == task.created_at
      "#{task.details} - Created"
    elsif task.is_completed
      "#{task.details} - Completed"
    else
      "#{task.details} - Updated"
    end.html_safe
  end
  
end

# case object
# when Animal
#   logger.debug("TESTING THIS OUT")
# end
